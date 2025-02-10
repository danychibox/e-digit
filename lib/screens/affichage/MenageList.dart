// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:edigit/screens/affichage/menage.dart';
import 'package:flutter/material.dart';
import 'package:edigit/Databasehelper.dart';
import 'package:edigit/screens/affichage/accueil.dart';
// import 'package:edigit/screens/affichage/personne.dart';
// import 'package:edigit/screens/affichage/visualisation.dart';
import 'package:edigit/screens/affichage/updateperson.dart';

class MenageList extends StatefulWidget {
  @override
  _MenageListState createState() => _MenageListState();
}

class _MenageListState extends State<MenageList> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _enfants;
  List<Map<String, dynamic>> _filteredEnfants = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _enfants = _dbHelper.getPersonDetailsNonSync();
    _enfants.then((data) {
      setState(() {
        _filteredEnfants = data;
      });
    });
    _searchController.addListener(_filterEnfants);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterEnfants() {
    setState(() {
      _filteredEnfants = _filteredEnfants
          .where((enfant) => (enfant['nom'] ?? '')
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Affiche une boîte de dialogue pour confirmer si l'utilisateur veut quitter
        final shouldExit = await _showExitConfirmationDialog(context);
        return shouldExit ??
            false; // Retourne true pour fermer, false pour rester
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (BuildContext context) {
                  return Accueil();
                }),
              );
            },
          ),
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 77, 68, 206),
          foregroundColor: Colors.white,
        ),
        // Corps de l'écran
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _enfants,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucune donnée offline'));
            } else {
              // Liste des données récupérées
              final enfants = snapshot.data!;

              return ListView.builder(
                itemCount: enfants.length,
                itemBuilder: (context, index) {
                  final enfant = enfants[index];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: ListTile(
                      tileColor: index % 2 == 0
                          ? Colors.grey.shade200
                          : Colors.white, // Couleur alternée
                      title: Text(
                        "${enfant['nom'] ?? ''} ${enfant['postnom'] ?? ''} ${enfant['prenom'] ?? ''}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("nom vul: ${enfant['pdisnvulabr'] ?? ''}"),
                          Text("lieu d'origine: ${enfant['provenance'] ?? ''}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.update,
                                color: const Color.fromARGB(255, 202, 151, 8)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPersonPage(
                                      localId: enfant['localid']),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool? confirm = await _showDeleteDialog(context);
                              if (confirm == true) {
                                await _dbHelper
                                    .deletePersonne(enfant['localid']);
                                setState(() {
                                  _enfants = _dbHelper.getPersonne0();
                                  _enfants.then((data) {
                                    _filteredEnfants = data;
                                  });
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Supprimé avec succès')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormMenage(),
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quitter'),
          content: Text('Voulez-vous vraiment quitter cette page ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Oui'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (BuildContext context) {
                  return Accueil();
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer cet enregistrement ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Supprimer'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
