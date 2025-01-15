// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_constructors_in_immutables

import 'package:edigit/screens/affichage/accueil.dart';
import 'package:flutter/material.dart';
import 'package:edigit/DatabaseHelper.dart';
import 'package:edigit/screens/affichage/MenageList.dart';
// import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

class FormInformation extends StatefulWidget {
  // final int userId;
  // const FormRecensement({super.key});
  FormInformation({super.key});

  @override
  State<FormInformation> createState() => _FormInformationState();
}

class _FormInformationState extends State<FormInformation> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _citNomController = TextEditingController();
  // final TextEditingController _citPrenomController = TextEditingController();
  // final TextEditingController _citPostNomController = TextEditingController();
  // final TextEditingController _citlieunaisController = TextEditingController();
  // final TextEditingController _citdatenaissController = TextEditingController();
  // final TextEditingController _ciBlocController = TextEditingController();
  final TextEditingController _nbjourController = TextEditingController();
  //final TextEditingController _observationController = TextEditingController();
  // final TextEditingController _avenueController = TextEditingController();
  final TextEditingController _compoController = TextEditingController();
  final TextEditingController _provenanceController = TextEditingController();
  final TextEditingController _tailleController = TextEditingController();
  // final TextEditingController _respoController = TextEditingController();
  // final TextEditingController _aireController = TextEditingController();
  // final TextEditingController _relationController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  // String? _selectedSexe;

  late Future<List<Map<String, dynamic>>> _motifs;
  int? _selectedMotifId;
  @override
  void initState() {
    super.initState();
    // _checkPermissions();
    _motifs = _dbHelper.getMotif();
    // _sites = _dbHelper.getsite(); // Initialisation des enfants
  }

  // Future<void> _pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  //   if (image != null) {
  //     setState(() {
  //       _selectedImage = File(image.path);
  //     });
  //   }
  // }

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
          title: const Text('RECENSEMENT DE PDIS'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 77, 68, 206),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Carte : Profilage

                  _buildCard(
                    title: 'INFORMATIONS SUR LE PDIS',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 450,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLength: 10, // Limite à 10 caractères
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // Accepte uniquement les chiffres
                            ],
                            controller: _compoController,
                            decoration: InputDecoration(
                              labelText: 'nombre d\'enfant',
                              counterText: '',
                              labelStyle: TextStyle(
                                color: Colors.black, // Couleur de l'étiquette
                                fontSize: 16,
                              ),
                              hintText: 'entrez le nombre d\'enfant',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.person_3_outlined,
                                  color: Colors.black),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez remplir ce champs';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 450,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLength: 10, // Limite à 10 caractères
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // Accepte uniquement les chiffres
                            ],
                            controller: _tailleController,
                            decoration: InputDecoration(
                              labelText: 'TAILLE DU MENAGE',
                              counterText: '',
                              labelStyle: TextStyle(
                                color: Colors.black, // Couleur de l'étiquette
                                fontSize: 16,
                              ),
                              hintText: 'entrez le nombre de personnes',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.black),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez remplir ce champs';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _provenanceController,
                          label: 'lieu de povenance',
                          hint: 'la provenance',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 450,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLength: 10, // Limite à 10 caractères
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // Accepte uniquement les chiffres
                            ],
                            controller: _nbjourController,
                            decoration: InputDecoration(
                              labelText: 'NOMBRE DE JOUR EN DEPLACEMENT',
                              counterText: '',
                              labelStyle: TextStyle(
                                color: Colors.black, // Couleur de l'étiquette
                                fontSize: 16,
                              ),
                              hintText: 'entrer le nombre',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.directions_car,
                                  color: Colors.black),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez remplir ce champs';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _motifs,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Erreur: ${snapshot.error}');
                            } else if (snapshot.hasData &&
                                snapshot.data!.isNotEmpty) {
                              return DropdownSearch<String>(
                                items: (f, cs) =>
                                    snapshot.data!.map<String>((site) {
                                  return site[
                                      'libmotif']; // Supposons que strucNom soit le nom de la structure
                                }).toList(),
                                selectedItem: _selectedMotifId != null
                                    ? snapshot.data!.firstWhere((s) =>
                                        s['localid'] ==
                                        _selectedMotifId)['libmotif']
                                    : null,
                                dropdownBuilder: (context, selectedItem) {
                                  return Text(
                                      selectedItem ?? 'motif de déplacement');
                                },
                                onChanged: (String? newValue) {
                                  setState(() {
                                    // Mettez à jour la logique pour extraire l'ID de la structure en fonction du nom
                                    _selectedMotifId = snapshot.data!
                                        .firstWhere(
                                            (s) => s['libmotif'] == newValue,
                                            orElse: () => {
                                                  'localid': null
                                                })['localid'] as int?;
                                  });
                                },
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  disabledItemFn: (item) =>
                                      item ==
                                      'Aucun motif', // Vous pouvez adapter cela selon vos besoins
                                  fit: FlexFit.loose,
                                ),
                              );
                            } else {
                              return const Text('Aucun motif disponible');
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: const Color.fromARGB(255, 77, 68, 206),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _savePersonne();
                        Navigator.push(context, MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          return MenageList();
                        }));
                      }
                    },
                    child: const Text(
                      'TERMINER',
                      style: TextStyle(
                        color: Colors
                            .white, // Change la couleur ici, par exemple rouge
                        fontSize:
                            18, // Tu peux aussi spécifier la taille de la police
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    Icon? prefixIcon,
  }) {
    return SizedBox(
      width: 450,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black, // Couleur de l'étiquette
            fontSize: 16,
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixIcon,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer du texte';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCard({required String title, required Widget content}) {
    return Card(
      color: Color.fromARGB(
          255, 255, 255, 255), // Couleur de fond douce pour la carte
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Coins arrondis
      ),
      elevation: 4, // Ombre pour l'effet d'élévation
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Divider(
              thickness: 1.5,
              color: Colors.blueAccent.withOpacity(0.5),
            ),
            SizedBox(height: 8),
            content, // Contenu de la carte
          ],
        ),
      ),
    );
  }

  Future<void> _savePersonne() async {
    try {
      List<Map<String, dynamic>> menage = await _dbHelper.getDernierMenages();
      int? codemenage = menage.first['localid'];
      List<Map<String, dynamic>> respo = await _dbHelper.getDernierPersonne();
      int? codeRespo = respo.first['localid'];
      List<Map<String, dynamic>> mat = await _dbHelper.getDernierPersonneMat();
      int? pdisresmat = mat.first['pdisresmat'];

      await _dbHelper.insertInfos({
        'provenance': _provenanceController.text,
        'nombreEnfant': _compoController.text,
        // 'observation': _observationController.text,
        'nbjour': _nbjourController.text,
        'motif': _selectedMotifId,
        'taillemen': _tailleController.text,
        'codeMenage': codemenage,
        'pdisresmat': pdisresmat,
        'respo': codeRespo,
      });

      // Vérifier si le widget est toujours monté avant d'utiliser Navigator ou showDialog
      if (!mounted) return;

      // Afficher une boîte de dialogue de succès
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Succès'),
            content: Text('ENREGISTREMENT TERMINÉ.'),
            actions: <Widget>[
              TextButton(
                child: Text('TERMINER'),
                onPressed: () {
                  // Vérifier si le widget est toujours monté avant d'utiliser Navigator
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                        return MenageList();
                      }),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Gestion des erreurs si nécessaire
      print('Erreur lors de l\'enregistrement: $e');
    }
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
}
