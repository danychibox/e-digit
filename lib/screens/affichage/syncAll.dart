import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:edigit/Databasehelper.dart';
import 'package:edigit/screens/affichage/accueil.dart';
import 'package:edigit/screens/affichage/enfantList1.dart';

class SyncAll extends StatefulWidget {
  @override
  _SyncAllState createState() => _SyncAllState();
}

class _SyncAllState extends State<SyncAll> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  // ignore: unused_field
  late Future<List<Map<String, dynamic>>> _enfants;

  @override
  void initState() {
    super.initState();
    _enfants = _dbHelper.getPersonne();
  }

  Future<void> sendRecOnline(BuildContext context) async {
    Dio dio = Dio();

    // Afficher le CircularProgressIndicator avant de commencer la synchronisation
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer le dialogue en cliquant à l'extérieur
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

    try {
      List<Map<String, dynamic>> enfants =
          await _dbHelper.getNonSyncedPersonnes();
      List<Map<String, dynamic>> user = await _dbHelper.getDernierUser();
      int? userId = user.first['userId'];

      for (var enfant in enfants) {
        var enfantToSend = Map<String, dynamic>.from(enfant);
        print(enfantToSend);

        // Créer un FormData avec les champs de l'enfant
        FormData formData = FormData.fromMap({
          "localid": enfant['localid'],
          "pdisresnom": enfant['nom'] ?? '',
          "pdisrespnom": enfant['postnom'] ?? '',
          "pdisresprenom": enfant['prenom'] ?? '',
          "pdisresgenre": enfant['sexe'] ?? '',
          "pdisresln": enfant['lieunais'] ?? '',
          "pdisresdtn": enfant['datenaiss'] ?? '',
          // "pdisresphoto": enfant['photo'] ?? '',
          "pdisresqualite": enfant['qualite'] ?? '',
          "pdisresnvul": enfant['observation'] ?? '',
          "pdisresprof": enfant['profession'] ?? '',
          "mena_code": enfant['codeMenage'] ?? '',
          "u_ref": userId ?? 0,
          "pdisresdatenr": enfant['date_crea'] ?? '',

          // "pdisresphoto": await MultipartFile.fromFile(
          //   enfant['photo'], // chemin de l'image à envoyer
          //   filename: "picture.jpg",
          // )
          // "u_id": userId,
          // "is_synced": enfant['is_synced'],
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

      // Fermer le CircularProgressIndicator après la synchronisation réussie
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour confirmer le succès
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Succès'),
            content: const Text('Données de PDIS synchronisées avec succès'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Fermer le CircularProgressIndicator en cas d'erreur
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour signaler l'échec
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Échec'),
            content: Text('Erreur lors de la synchronisation des PDIS : $e'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Erreur lors de la synchronisation des donnees : $e');
    }
  }

  //envoyer meres
  Future<void> sendMenageOnline(BuildContext context) async {
    Dio dio = Dio();

    // Afficher le CircularProgressIndicator avant de commencer la synchronisation
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer le dialogue en cliquant à l'extérieur
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

      // Fermer le CircularProgressIndicator après la synchronisation réussie
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour confirmer le succès
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Succès'),
            content: const Text('menages synchronisés avec succès'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Fermer le CircularProgressIndicator en cas d'erreur
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour signaler l'échec
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Échec'),
            content: const Text(
                'Erreur lors de la synchronisation des informations : des menage'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Erreur lors de la synchronisation des informationss : $e');
    }
  }

//declarant
  Future<void> sendInfosOnline(BuildContext context) async {
    Dio dio = Dio();

    // Afficher le CircularProgressIndicator avant de commencer la synchronisation
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer le dialogue en cliquant à l'extérieur
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

    try {
      List<Map<String, dynamic>> pdisinfos =
          await _dbHelper.getNonSyncedInfos();
      List<Map<String, dynamic>> user = await _dbHelper.getDernierUser();
      int? userId = user.first['userId'];

      for (var pdisinfo in pdisinfos) {
        var pdisinfoToSend = Map<String, dynamic>.from(pdisinfo);
        print(pdisinfoToSend);

        // Créer un FormData avec les champs de l'enfant
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
        print(response.data);
        if (response.statusCode == 200) {
          await _dbHelper.updatePersonneSyncedStatus(pdisinfo['localid']);
          print('personne synchronisé avec succès : ${pdisinfo['nbjour']}');
          print('${response.data}');
        } else {
          print(
              'Erreur lors de la synchronisation de ${pdisinfo['nbjour']}: ${response.statusCode}, ${response.data}');
        }
      }

      // Fermer le CircularProgressIndicator après la synchronisation réussie
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour confirmer le succès
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Succès'),
            content: const Text('pdisinfos synchronisés avec succès'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Fermer le CircularProgressIndicator en cas d'erreur
      Navigator.of(context).pop(); // Fermer le loader

      // Afficher une boîte de dialogue pour signaler l'échec
      showDialog(
        context: context, // Le context est maintenant disponible
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Échec'),
            content: Text('Erreur lors de la synchronisation des pdisinfos '),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              ),
            ],
          );
        },
      );

      print('Erreur lors de la synchronisation des declarants : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Couleur de la flèche de retour
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Icône de la flèche de retour
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (BuildContext context) {
                return Accueil();
              }),
            );
          },
        ),
        title: const Text(
          'synchroniser les donnees',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 77, 68, 206),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSquareButton(
                  context,
                  'synchroniser les PDIS',
                  () {
                    sendRecOnline(context);
                  },
                  Icons.people,
                ),
                _buildSquareButton(
                  context,
                  'synchroniser les menages',
                  () {
                    sendMenageOnline(context);
                  },
                  Icons.people,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSquareButton(
                  context,
                  'synchroniser les informations de PDIS',
                  () {
                    sendInfosOnline(context);
                  },
                  Icons.people,
                ),
                _buildSquareButton(
                  context,
                  'données en ligne',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Enfantlist1(),
                      ),
                    );
                  },
                  Icons.people,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareButton(BuildContext context, String text,
      VoidCallback onPressed, IconData icon) {
    return SizedBox(
      width: 200,
      height: 160,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 77, 68, 206),
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textStyle: const TextStyle(fontSize: 16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40.0,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}
