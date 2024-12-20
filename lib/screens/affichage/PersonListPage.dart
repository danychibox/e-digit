import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:edigit/Databasehelper.dart';

class PersonListPage extends StatefulWidget {
  @override
  _PersonListPageState createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _personnes;

  @override
  void initState() {
    super.initState();
    _personnes = _dbHelper.getPersonne();
  }

  // Fonction pour envoyer les données en ligne
  Future<void> _sendDataOnline(Map<String, dynamic> personne) async {
    final response = await http.post(
      Uri.parse(
          'https://rece-api.etatcivilnordkivu.cd/API_ETAT_CIVIL_FINS/citoyen/save?user=etatcivil&mdp=nordkivu'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'citnom': personne['nom'],
        'citpnom': personne['postnom'],
        'citprenom': personne['prenom'],
        'citsexe': personne['sexe'],
        'citlieunais': personne['lieunais'],
        'citdatenaiss': personne['datenaiss'],
        'citnationalite': personne['nationalite'],
        'citphone': personne['phone'],
        'date_inscri': personne['date_inscri'],
        'ec_id': personne['ec_id'].toString(),
        'kaz_id': personne['kaz_id'].toString(),
        'u_id': personne['u_id'].toString(),
        'mena_id': personne['mena_id'].toString(),
        'rl_id': personne['rl_id'].toString(),
        'cert_imag': personne['cert_imag'],
        'cit_declarant': personne['cit_declarant'],
        'struc_id': personne['struc_id'].toString(),
      }),
    );

    if (response.statusCode == 200) {
      _deletePerson(personne['citid']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'envoi des données en ligne')),
      );
    }
  }

  // Fonction pour supprimer les données dans SQLite
  void _deletePerson(int id) async {
    final db = await _dbHelper.database;
    await db.delete('personne', where: 'localid = ?', whereArgs: [id]);
    setState(() {
      _personnes = _dbHelper.getPersonne(); // Rafraîchir la liste
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des personnes recensées',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 77, 68, 206),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _personnes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune personne enregistrée'));
          } else {
            final personnes = snapshot.data!;
            return ListView.separated(
              padding: EdgeInsets.all(16.0),
              itemCount: personnes.length,
              itemBuilder: (context, index) {
                final personne = personnes[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 77, 68, 206),
                      child: Text(
                        personne['nom'][0],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      '${personne['nom']} ${personne['postnom']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'genre: ${personne['citsexe']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        _sendDataOnline(personne);
                      },
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 10),
            );
          }
        },
      ),
    );
  }
}
