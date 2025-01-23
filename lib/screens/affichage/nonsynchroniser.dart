// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:edigit/screens/affichage/enfantList1.dart';
import 'package:flutter/material.dart';
import 'package:edigit/DatabaseHelper.dart';
import 'package:edigit/screens/affichage/accueil.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'package:dio/dio.dart';

class UnsyncedPersonsPage extends StatefulWidget {
  const UnsyncedPersonsPage({super.key});

  @override
  _UnsyncedPersonsPageState createState() => _UnsyncedPersonsPageState();
}

class _UnsyncedPersonsPageState extends State<UnsyncedPersonsPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _unsyncedPersons;

  @override
  void initState() {
    super.initState();
    _unsyncedPersons = _dbHelper.getNonSyncedPersonnes();
  }

  Future<void> _sendData(BuildContext context) async {
    try {
      // Affichage du loader
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

      // Vérification et exécution des méthodes avec gestion des erreurs
      try {
        await sendRecOnline(context);
        print('sendRecOnline exécuté avec succès.');
      } catch (e) {
        print('Erreur lors de sendRecOnline : $e');
        if (context.mounted) {
          await _showErrorDialog(context, 'Erreur lors de sendRecOnline : $e');
        }
      }

      try {
        await sendMenageOnline(context);
        print('sendMenageOnline exécuté avec succès.');
      } catch (e) {
        print('Erreur lors de sendMenageOnline : $e');
        if (context.mounted) {
          await _showErrorDialog(
              context, 'Erreur lors de sendMenageOnline : $e');
        }
      }

      try {
        await sendInfosOnline(context);
        print('sendInfosOnline exécuté avec succès.');
      } catch (e) {
        print('Erreur lors de sendInfosOnline : $e');
        if (context.mounted) {
          await _showErrorDialog(
              context, 'Erreur lors de sendInfosOnline : $e');
        }
      }

      // Fermer le loader si le contexte est valide
      if (context.mounted) Navigator.of(context).pop();

      // Succès global
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Succès'),
              content: const Text(
                  'Toutes les données ont été synchronisées avec succès.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _unsyncedPersons = _dbHelper.getNonSyncedPersonnes();
                    });
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Fermer le loader en cas d'erreur globale
      if (context.mounted) Navigator.of(context).pop();

      // Afficher une erreur globale
      print('Erreur lors de la synchronisation globale : $e');
      if (context.mounted) {
        await _showErrorDialog(
            context, 'Erreur globale lors de la synchronisation : $e');
      }
    }
  }

// Méthode auxiliaire pour afficher une boîte de dialogue d'erreur
  Future<void> _showErrorDialog(BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Échec'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendRecOnline(BuildContext context) async {
    Dio dio = Dio();
    try {
      List<Map<String, dynamic>> enfants =
          await _dbHelper.getNonSyncedPersonnes();
      List<Map<String, dynamic>> user = await _dbHelper.getDernierUser();
      int? userId = user.first['userId'];

      for (var enfant in enfants) {
        var enfantToSend = Map<String, dynamic>.from(enfant);
        print(enfantToSend);
        // String? sexe = "F";
        // if (enfant['sexe'] == "Masculin") {
        //   sexe = "M";
        // }
        // Créer un FormData avec les champs de l'enfant
        FormData formData = FormData.fromMap({
          "localid": enfant['localid'],
          "pdisresnom": enfant['nom'] ?? '',
          "pdisrespnom": enfant['postnom'] ?? '',
          "pdisresprenom": enfant['prenom'] ?? '',
          "pdisresgenre": enfant['sexe'] ?? '',
          "pdisresln": enfant['lieunais'] ?? '',
          "pdisresdtn": enfant['datenaiss'] ?? '',
          "pdisresqualite": enfant['relation'] ?? '',
          "pdisresnvul": enfant['vulenerabilite'] ?? '',
          "pdisresprof": enfant['profession'] ?? '',
          // "matricule": "NK0000$userId${enfant['localid']}${sexe}BBO",
          "mena_code": enfant['codeMenage'] ?? '',
          "u_ref": userId ?? 0,
          "pdisresdatenr": enfant['date_inscri'] ?? '',
        });

        // Envoi de la requête
        final response = await dio.post(
          'https://rece-api.etatcivilnordkivu.cd/api_rece_dep/personne/save?user=recedepv1&mdp=nk001api',
          data: formData,
        );

        if (response.statusCode == 200) {
          await _dbHelper.updatePersonneSyncedStatus(enfant['localid']);
          print('Données synchronisées avec succès : ${enfant['nom']}');
          print('${response.data}');
        } else {
          print(
              'Erreur lors de la synchronisation de ${enfant['nom']}: ${response.statusCode}, ${response.data}');
        }
      }
    } catch (e) {
      print('Erreur lors de la synchronisation des donnees : $e');
    }
  }

  //envoyer meres
  Future<void> sendMenageOnline(BuildContext context) async {
    Dio dio = Dio();

    // Afficher le CircularProgressIndicator avant de commencer la synchronisation

    try {
      List<Map<String, dynamic>> menages =
          await _dbHelper.getNonSyncedMenages();
      List<Map<String, dynamic>> user = await _dbHelper.getDernierUser();
      int? userId = user.first['userId'];

      for (var menage in menages) {
        var menageToSend = Map<String, dynamic>.from(menage);
        print(menageToSend);

        // Créer un FormData avec les champs de l'enfant
        FormData formData = FormData.fromMap({
          "localid": menage['localid'],
          "qr_id": menage['qr_id'],
          "menaresidance": menage['avenue'],
          "menanumparc": menage['menanumparc'],
          "localisation": menage['localisation'],
          "zone_id": menage['zonesante'],
          "menasitua": menage['menasitua'],
          "nomresp": menage['nomrespo'],
          "phone": menage['phone'],
          "taillemenage": menage['taillemenage'],
          "date_crea": menage['date_inscri'],
          "u_id": userId,
        });

        // Envoi de la requête
        final response = await dio.post(
          'https://rece-api.etatcivilnordkivu.cd/api_rece_dep/menage/save?user=recedepv1&mdp=nk001api',
          data: formData,
        );

        if (response.statusCode == 200) {
          await _dbHelper.updateMenageSyncedStatus(menage['localid']);
          print('Enfant synchronisé avec succès : ${menage['nom']}');
          print('${response.data}');
        } else {
          print(
              'Erreur lors de la synchronisation de ${menage['nom']}: ${response.statusCode}, ${response.data}');
        }
      }
    } catch (e) {
      print('Erreur lors de la synchronisation des informationss : $e');
    }
  }

//declarant
  Future<void> sendInfosOnline(BuildContext context) async {
    Dio dio = Dio();

    try {
      List<Map<String, dynamic>> pdisinfos =
          await _dbHelper.getNonSyncedInfos();
      List<Map<String, dynamic>> user = await _dbHelper.getDernierUser();
      int? userId = user.first['userId'];

      for (var pdisinfo in pdisinfos) {
        var pdisinfoToSend = Map<String, dynamic>.from(pdisinfo);
        print(pdisinfoToSend);
        List<Map<String, dynamic>> xcode =
            await _dbHelper.getPersonneAndInfosByMenage();
        String? enfantid;
        String? enfantsexe;
        if (xcode.isNotEmpty) {
          // Extraction des premières données
          enfantid = xcode.first['personneId'] as String?;
          enfantsexe = xcode.first['sexe'] as String?;

          // Utilisation des données récupérées
          print('Enfant ID: $enfantid');
          print('Enfant Sexe: $enfantsexe');
        } else {
          // Gestion du cas où aucune donnée n'est trouvée
          enfantid = '';
          enfantsexe = '';
          print(
              'Aucune donnée trouvée pour le codeMenage : ${pdisinfo['codeMenage']}');
        }
        // var enfantid = xcode.first['personneId'];
        // var enfantsexe = xcode.first['sexePersonne'];
        // Créer un FormData avec les champs de l'enfant
        FormData formData = FormData.fromMap({
          "localid": pdisinfo['localid'],
          "pdisinfonenf": pdisinfo['nombreEnfant'],
          "pdisinfotmen": pdisinfo['taillemen'],
          "pdisinfolieuprov": pdisinfo['provenance'],
          "pdisinfomotdep": pdisinfo['motif'],
          "pdisinfonomjourdep": pdisinfo['nbjour'],
          "idmenaccueil": pdisinfo['codeMenage'],
          "matriculepdis": "NK0000$userId$enfantid${enfantsexe}BBO",
          "u_id": userId,
        });

        // Envoi de la requête
        final response = await dio.post(
          'https://rece-api.etatcivilnordkivu.cd/api_rece_dep/pdisinfo/save?user=recedepv1&mdp=nk001api',
          data: formData,
        );
        print(response.data);
        if (response.statusCode == 200) {
          await _dbHelper.updateInfoSyncedStatus(pdisinfo['localid']);
          print('personne synchronisé avec succès : ${pdisinfo['nbjour']}');
          print('${response.data}');
        } else {
          print(
              'Erreur lors de la synchronisation de ${pdisinfo['nbjour']}: ${response.statusCode}, ${response.data}');
        }
      }
    } catch (e) {
      print('Erreur lors de la synchronisation des informations du pdis : $e');
    }
  }

  // List<bool> _checkedItems = [false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Accueil()),
            );
          },
        ),
        title: const Text(
          'Prêt à envoyer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 77, 68, 206),
        foregroundColor: Colors.white,
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.sync),
        //     tooltip: 'synchroniser',
        //     onPressed: () => _sendData(context),
        //   ),
        // ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _unsyncedPersons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Aucune donnée non synchronisée.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            final persons = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: persons.length,
              itemBuilder: (context, index) {
                final person = persons[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 77, 68, 206),
                      child: Text(
                        person['nom'][0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      '${person['nom']} ${person['postnom']} ${person['prenom']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        // ignore: prefer_const_literals_to_cr
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Fond blanc
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Pas de bordure arrondie
                  side: BorderSide(
                      color: Colors.black, width: 2), // Bordure noire
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () async {
                _sendData(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tout envoyer',
                    style: TextStyle(color: Colors.black), // Texte en noir
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.cloud_upload),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Fond blanc
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Pas de coins arrondis
                  side: BorderSide(
                      color: Colors.black, width: 2), // Bordure noire
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Enfantlist1(),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Donnée en ligne',
                    style: TextStyle(color: Colors.black), // Texte en noir
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_upward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
