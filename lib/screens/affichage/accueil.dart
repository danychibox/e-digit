// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:edigit/screens/affichage/menage.dart';
import 'package:flutter/material.dart';
import 'package:edigit/DatabaseHelper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:edigit/screens/affichage/MenageList.dart';
import 'package:edigit/screens/affichage/enfantList1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edigit/screens/authentification/login.dart';
import 'package:dio/dio.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> count = [];
  int? countnonsync;
  int? countday;
  int? countsync;

  @override
  void initState() {
    super.initState();
    _loadUnsyncedPersonneCount();
    _loadsyncedPersonneCount();
    _parjourData();
  }

  Future<void> _loadUnsyncedPersonneCount() async {
    count = await _dbHelper.countUnsyncedPersonne();
    setState(() {
      countnonsync = count.first['count'];
    });
  }

  Future<void> _parjourData() async {
    int countToday = await _dbHelper.countDataByToday();
    setState(() {
      countday = countToday;
    });
  }

  Future<void> _loadsyncedPersonneCount() async {
    count = await _dbHelper.countSyncedPersonne();
    setState(() {
      countsync = count.first['count'];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            SizedBox(width: 10),
            Text('E-DIGIT'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.cloudArrowUp),
            onPressed: () async {
              sendInfosOnline(context);
            },
          ),
        ],
        automaticallyImplyLeading: true,
        backgroundColor: const Color.fromARGB(255, 77, 68, 206),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 77, 68, 206),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.sync_alt),
              title: Text('Synchroniser les quartier'),
              onTap: () => syncAdresseFromApi(context),
            ),
            ListTile(
              leading: Icon(Icons.sync_alt),
              title: Text('Synchroniser les aires de santé'),
              onTap: () => syncZoneFromApi(context),
            ),
            ListTile(
              leading: Icon(Icons.sync_alt),
              title: Text('Synchroniser motif des deplacement'),
              onTap: () => syncMotifFromApi(context),
            ),
            ListTile(
              leading: Icon(Icons.sync_alt),
              title: Text('Synchroniser les vulnérabilités'),
              onTap: () => syncVulenerableFromApi(context),
            ),
            ListTile(
              leading: Icon(Icons.sync_alt),
              title: Text('Synchroniser les professions'),
              onTap: () => syncProfessionFromApi(context),
            ),
            ListTile(
              leading: Icon(Icons.sync),
              title: Text('Synchroniser les utilisateurs'),
              onTap: () => syncUserFromApi(context),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Quitter l\'application'),
              onTap: () async {
                final shouldExit = await _showExitDialog(context);
                if (shouldExit) exit(0);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centrer les éléments verticalement
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 5),
                            Icon(
                              Icons.storage,
                              size: 20,
                              color: Colors.red,
                            ),
                            Text(
                              'Enregistrements en attente',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            width: 5), // Espacement entre l'icône et le texte
                        Text(
                          '$countnonsync',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centrer les éléments verticalement
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 5),
                            Icon(
                              Icons.storage,
                              size: 20,
                              color: Colors.orange,
                            ),
                            Text(
                              'Données synchronisées',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 5),
                        Text(
                          '$countsync',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 5),
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Centrer les éléments verticalement
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Espacement entre l'icône et le texte
                          Row(
                            children: [
                              Icon(
                                Icons.storage,
                                size: 20,
                                color: Colors.green,
                              ),
                              Text(
                                'Données en temps réel',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),

                          Text(
                            '$countday',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
              _buildSquareButton(
                context,
                'Ajouter',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormMenage(),
                    ),
                  );
                },
                Icons.add,
                screenWidth * 0.4, // Adapté à la largeur de l’écran
                screenHeight * 0.2,
              ),
              _buildSquareButton(
                context,
                'Données enregistrées',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenageList(),
                    ),
                  );
                },
                Icons.people,
                screenWidth * 0.4,
                screenHeight * 0.2,
              ),
              _buildSquareButton(
                context,
                'Données en ligne',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Enfantlist1(),
                    ),
                  );
                },
                Icons.list,
                screenWidth * 0.4,
                screenHeight * 0.2,
              ),
              _buildSquareButton(
                context,
                'Synchronisation',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                Icons.sync_alt_rounded,
                screenWidth * 0.4,
                screenHeight * 0.2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquareButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
    IconData icon,
    double width,
    double height,
  ) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 77, 68, 206),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(fontSize: 16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: Colors.white),
            SizedBox(height: 5),
            Text(text),
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> fetchQuartierFromApi() async {
    final response = await http.get(Uri.parse(
        'https://rece-api.etatcivilnordkivu.cd/api_rece_dep/site/get/all?user=recedepv1&mdp=nk001api'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      // Vérifiez si la réponse est une liste ou un objet
      if (jsonData is Map && jsonData.containsKey('response')) {
        return jsonData['response']; // Retournez la liste sous 'response'
      } else if (jsonData is List) {
        return jsonData; // Si c'est déjà une liste, retournez-la
      } else {
        throw Exception('Format de réponse inattendu');
      }
    } else {
      throw Exception('Échec de chargement de l\'API');
    }
  }

  Future<List<dynamic>> fetchZoneFromApi() async {
    final response = await http.get(Uri.parse(
        'https://rece-api.etatcivilnordkivu.cd/api_rece_dep/aire/get/all?user=recedepv1&mdp=nk001api'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      // Vérifiez si la réponse est une liste ou un objet
      if (jsonData is Map && jsonData.containsKey('response')) {
        return jsonData['response']; // Retournez la liste sous 'response'
      } else if (jsonData is List) {
        return jsonData; // Si c'est déjà une liste, retournez-la
      } else {
        throw Exception('Format de réponse inattendu');
      }
    } else {
      throw Exception('Échec de chargement de l\'API');
    }
  }

  Future<List<dynamic>> fetchMotifFromApi() async {
    final response = await http.get(Uri.parse(
        'https://rece-api.etatcivilnordkivu.cd/api_rece_dep/motif/get/all?user=recedepv1&mdp=nk001api'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      // Vérifiez si la réponse est une liste ou un objet
      if (jsonData is Map && jsonData.containsKey('response')) {
        return jsonData['response']; // Retournez la liste sous 'response'
      } else if (jsonData is List) {
        return jsonData; // Si c'est déjà une liste, retournez-la
      } else {
        throw Exception('Format de réponse inattendu');
      }
    } else {
      throw Exception('Échec de chargement de l\'API');
    }
  }

  Future<List<dynamic>> fetchVulenerableFromApi() async {
    final response = await http.get(Uri.parse(
        'https://rece-api.etatcivilnordkivu.cd/api_rece_dep/vulenerable/get/all?user=recedepv1&mdp=nk001api'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      // Vérifiez si la réponse est une liste ou un objet
      if (jsonData is Map && jsonData.containsKey('response')) {
        return jsonData['response']; // Retournez la liste sous 'response'
      } else if (jsonData is List) {
        return jsonData; // Si c'est déjà une liste, retournez-la
      } else {
        throw Exception('Format de réponse inattendu');
      }
    } else {
      throw Exception('Échec de chargement de l\'API');
    }
  }

  Future<List<dynamic>> fetchProfessionFromApi() async {
    final response = await http.get(Uri.parse(
        'https://rece-api.etatcivilnordkivu.cd/api_rece_dep/profession/get/all?user=recedepv1&mdp=nk001api'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      // Vérifiez si la réponse est une liste ou un objet
      if (jsonData is Map && jsonData.containsKey('response')) {
        return jsonData['response']; // Retournez la liste sous 'response'
      } else if (jsonData is List) {
        return jsonData; // Si c'est déjà une liste, retournez-la
      } else {
        throw Exception('Format de réponse inattendu');
      }
    } else {
      throw Exception('Échec de chargement de l\'API');
    }
  }

  Future<List<dynamic>> fetchUserFromApi() async {
    final response = await http.get(Uri.parse(
        'https://rece-api.etatcivilnordkivu.cd/api_rece_dep/user/get/all?user=recedepv1&mdp=nk001api'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      // Vérifiez si la réponse est une liste ou un objet
      if (jsonData is Map && jsonData.containsKey('response')) {
        return jsonData['response']; // Retournez la liste sous 'response'
      } else if (jsonData is List) {
        return jsonData; // Si c'est déjà une liste, retournez-la
      } else {
        throw Exception('Format de réponse inattendu');
      }
    } else {
      throw Exception('Échec de chargement de l\'API');
    }
  }

  Future<void> syncAdresseFromApi(BuildContext context) async {
    // Afficher le CircularProgressIndicator avant de commencer la synchronisation
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer le dialogue en cliquant à l'extérieur
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 15),
              Text(
                'Synchronisation en cours...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );

    try {
      // Étape 1 : Récupérer les données depuis l'API
      List<dynamic> dataQuartierFromApi = await fetchQuartierFromApi();
      // Étape 2 : Insérer chaque élément dans la base de données SQLite
      for (var item in dataQuartierFromApi) {
        Map<String, dynamic> site = {
          'localid': item['qrid'].toString(),
          'cm_id': item['cm_id'].toString(),
          'qrlib': item['qrlib'].toString(),
        };

        // Insertion dans SQLite
        final dbHelper = DatabaseHelper();
        await dbHelper.insertSite(site);
      }

      // Fermer le CircularProgressIndicator après la synchronisation réussie
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour confirmer le succès
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Succès'),
            content: Text('Données synchronisées avec succès'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Données synchronisées avec succès');
    } catch (error) {
      // Fermer le CircularProgressIndicator en cas d'erreur
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour signaler l'échec
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Échec'),
            content: Text('Erreur lors de la synchronisation des données '),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Erreur lors de la synchronisation des données ');
    }
  }

  Future<void> syncZoneFromApi(BuildContext context) async {
    // Afficher le CircularProgressIndicator avant de commencer la synchronisation
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer le dialogue en cliquant à l'extérieur
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 15),
              Text(
                'Synchronisation en cours...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );

    try {
      // Étape 1 : Récupérer les données depuis l'API
      List<dynamic> dataZoneFromApi = await fetchZoneFromApi();
      // Étape 2 : Insérer chaque élément dans la base de données SQLite
      for (var item in dataZoneFromApi) {
        Map<String, dynamic> zone = {
          'localid': item['pdisairsant'].toString(),
          'designation': item['pdisairsantlib'].toString(),
          'zone': item['zone_Id'].toString(),
        };

        // Insertion dans SQLite
        final dbHelper = DatabaseHelper();
        await dbHelper.insertZone(zone);
      }

      // Fermer le CircularProgressIndicator après la synchronisation réussie
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour confirmer le succès
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Succès'),
            content: Text('Données synchronisées avec succès'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Données synchronisées avec succès');
    } catch (error) {
      // Fermer le CircularProgressIndicator en cas d'erreur
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour signaler l'échec
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Échec'),
            content: Text('Erreur lors de la synchronisation des données '),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Erreur lors de la synchronisation des données ');
    }
  }

  Future<void> syncUserFromApi(BuildContext context) async {
    // Afficher le CircularProgressIndicator avant de commencer la synchronisation
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer le dialogue en cliquant à l'extérieur
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 15),
              Text(
                'Synchronisation en cours...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );

    try {
      // Étape 1 : Récupérer les données depuis l'API
      List<dynamic> dataFromApi = await fetchUserFromApi();

      // Étape 2 : Insérer chaque élément dans la base de données SQLite
      for (var item in dataFromApi) {
        Map<String, dynamic> user = {
          'userId': item['uid'].toString(),
          'username': item['uref'].toString(),
          'mdp': item['upass'].toString(),
          'nom_complet': item['upseudo'].toString()
        };

        // Insertion dans SQLite
        final dbHelper = DatabaseHelper();
        await dbHelper.insertUser(user);
      }

      // Fermer le CircularProgressIndicator après la synchronisation réussie
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour confirmer le succès
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Succès'),
            content: Text('Données synchronisées avec succès'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Données synchronisées avec succès');
    } catch (error) {
      // Fermer le CircularProgressIndicator en cas d'erreur
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour signaler l'échec
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Échec'),
            content: Text('Erreur lors de la synchronisation des données'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Erreur lors de la synchronisation des données ');
    }
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmer'),
            content: Text('Voulez-vous vraiment quitter l\'application ?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Non')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Oui')),
            ],
          ),
        )) ??
        false;
  }

  Future<void> syncMotifFromApi(BuildContext context) async {
    // Afficher le CircularProgressIndicator avant de commencer la synchronisation
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer le dialogue en cliquant à l'extérieur
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 15),
              Text(
                'Synchronisation en cours...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );

    try {
      // Étape 1 : Récupérer les données depuis l'API
      List<dynamic> dataMotifFromApi = await fetchMotifFromApi();
      // Étape 2 : Insérer chaque élément dans la base de données SQLite
      for (var item in dataMotifFromApi) {
        Map<String, dynamic> motif = {
          'localid': item['pdismotifdepid'].toString(),
          'libmotif': item['pdismotifdeplib'].toString(),
        };

        // Insertion dans SQLite
        final dbHelper = DatabaseHelper();
        await dbHelper.insertMotif(motif);
      }

      // Fermer le CircularProgressIndicator après la synchronisation réussie
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour confirmer le succès
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Succès'),
            content: Text('Données synchronisées avec succès'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Données synchronisées avec succès');
    } catch (error) {
      // Fermer le CircularProgressIndicator en cas d'erreur
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour signaler l'échec
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Échec'),
            content: Text('Erreur lors de la synchronisation des données '),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Erreur lors de la synchronisation des données ');
    }
  }

  Future<void> syncVulenerableFromApi(BuildContext context) async {
    // Afficher le CircularProgressIndicator avant de commencer la synchronisation
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer le dialogue en cliquant à l'extérieur
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 15),
              Text(
                'Synchronisation en cours...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );

    try {
      // Étape 1 : Récupérer les données depuis l'API
      List<dynamic> dataMotifFromApi = await fetchVulenerableFromApi();
      // Étape 2 : Insérer chaque élément dans la base de données SQLite
      for (var item in dataMotifFromApi) {
        Map<String, dynamic> motif = {
          'localid': item['pdisnvulid'].toString(),
          'pdisnvulabr': item['pdisnvulabr'].toString(),
          'pdisnvullib': item['pdisnvullib'].toString(),
        };

        // Insertion dans SQLite
        final dbHelper = DatabaseHelper();
        await dbHelper.insertVulenerable(motif);
      }

      // Fermer le CircularProgressIndicator après la synchronisation réussie
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour confirmer le succès
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Succès'),
            content: Text('Données synchronisées avec succès'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Données synchronisées avec succès');
    } catch (error) {
      // Fermer le CircularProgressIndicator en cas d'erreur
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour signaler l'échec
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Échec'),
            content: Text('Erreur lors de la synchronisation des données '),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Erreur lors de la synchronisation des données ');
    }
  }

  Future<void> syncProfessionFromApi(BuildContext context) async {
    // Afficher le CircularProgressIndicator avant de commencer la synchronisation
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer le dialogue en cliquant à l'extérieur
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 15),
              Text(
                'Synchronisation en cours...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );

    try {
      // Étape 1 : Récupérer les données depuis l'API
      List<dynamic> dataMotifFromApi = await fetchProfessionFromApi();
      // Étape 2 : Insérer chaque élément dans la base de données SQLite
      for (var item in dataMotifFromApi) {
        Map<String, dynamic> prof = {
          'localid': item['kazid'].toString(),
          'kazlib': item['kazlib'].toString(),
        };

        // Insertion dans SQLite
        final dbHelper = DatabaseHelper();
        await dbHelper.insertProfession(prof);
      }

      // Fermer le CircularProgressIndicator après la synchronisation réussie
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour confirmer le succès
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Succès'),
            content: Text('Données synchronisées avec succès'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Données synchronisées avec succès');
    } catch (error) {
      // Fermer le CircularProgressIndicator en cas d'erreur
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour signaler l'échec
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Échec'),
            content: Text('Erreur lors de la synchronisation des données '),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Erreur lors de la synchronisation des données ');
    }
  }

  Future<void> sendInfosOnline(BuildContext context) async {
    Dio dio = Dio();
    final dbHelper = DatabaseHelper();

    try {
      // Afficher le dialogue de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 15),
                Text(
                  'Synchronisation en cours...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
      );

      // Récupérer les enregistrements et l'utilisateur
      List<Map<String, dynamic>> pdisinfos = await dbHelper.getNonSyncedInfos();
      List<Map<String, dynamic>> user = await dbHelper.getDernierUser();
      int? userId = user.first['userId'];

      // Boucle pour traiter chaque enregistrement
      for (var pdisinfo in pdisinfos) {
        try {
          FormData formData = FormData.fromMap({
            "localid": pdisinfo['localid'],
            "pdisinfonenf": pdisinfo['nombreEnfant'],
            "pdisinfotmen": pdisinfo['taillemen'],
            "pdisinfolieuprov": pdisinfo['provenance'],
            "pdisinfomotdep": pdisinfo['motif'],
            "pdisinfonomjourdep": pdisinfo['nbjour'],
            "idmenaccueil": pdisinfo['codeMenage'],
            "u_id": userId,
          });

          // Envoi de la requête
          final response = await dio.post(
            'https://rece-api.etatcivilnordkivu.cd/api_rece_dep/pdisinfo/save?user=recedepv1&mdp=nk001api',
            data: formData,
          );

          // Vérification du succès de la requête
          if (response.statusCode == 200) {
            await dbHelper.updateInfoSyncedStatus(pdisinfo['localid']);
          } else {
            print(
                'Erreur lors de la synchronisation : ${response.statusCode} - ${response.data}');
          }
        } catch (e) {
          print(
              'Erreur lors de la synchronisation de ${pdisinfo['localid']}: $e');
        }
      }

      // Fermer le dialogue de chargement
      if (context.mounted) Navigator.of(context).pop();

      // Afficher un message de succès
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Succès'),
            content: const Text('Données synchronisées avec succès'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Gestion des erreurs globales
      if (context.mounted) Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: const Text(
                'Une erreur est survenue lors de la synchronisation des données'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print('Erreur globale lors de la synchronisation : $e');
    }
  }
}
