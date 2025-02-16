// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:edigit/Databasehelper.dart';
import 'package:edigit/screens/affichage/accueil.dart';
// import 'package:edigit/screens/affichage/visualisation.dart';

class Enfantlist1 extends StatefulWidget {
  @override
  _Enfantlist1State createState() => _Enfantlist1State();
}

class _Enfantlist1State extends State<Enfantlist1> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _personnes;

  @override
  void initState() {
    super.initState();
    _personnes = _dbHelper.getPersonDetailsSync();
  }

  // Fonction pour envoyer les données en ligne

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Couleur de la flèche de retour
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icône de la flèche de retour
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (BuildContext context) {
                return Accueil();
              }),
            );
          },
        ),
        title: Text(
          'LISTE DES RECENSES',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 77, 68, 206),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
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
                      '${personne['nom']} ${personne['postnom']} ${personne['prenom']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Vulnérabilité: ${personne['pdisnvulabr'] ?? ''}"),
                        Text("Lieu d'origine: ${personne['provenance'] ?? ''}"),
                      ],
                    ),
                    // trailing: IconButton(
                    //   icon: Icon(Icons.send, color: Colors.blue),
                    //   onPressed: () {
                    //     // _sendDataOnline(enfant);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => EnfantDetailsScreen(
                    //             personneId: personne[
                    //                 'localid']), // Remplace 1 par l'ID de l'enfant souhaité
                    //       ),
                    //     );
                    //   },
                    // ),
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
