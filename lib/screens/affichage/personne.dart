// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:edigit/DatabaseHelper.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter/services.dart';
import 'package:edigit/screens/affichage/information.dart';

class FormPersonne extends StatefulWidget {
  // final int userId;
  // const FormRecensement({super.key});
  FormPersonne({super.key});

  @override
  State<FormPersonne> createState() => _FormPersonneState();
}

class _FormPersonneState extends State<FormPersonne> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _citNomController = TextEditingController();
  final TextEditingController _citPrenomController = TextEditingController();
  final TextEditingController _citPostNomController = TextEditingController();
  final TextEditingController _citlieunaisController = TextEditingController();
  final TextEditingController _citdatenaissController = TextEditingController();
  final TextEditingController _observationController = TextEditingController();
  // final TextEditingController _motifController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  // final TextEditingController _compoController = TextEditingController();
  // final TextEditingController _provenanceController = TextEditingController();
  // final TextEditingController _tailleController = TextEditingController();
  // final TextEditingController _respoController = TextEditingController();
  // final TextEditingController _aireController = TextEditingController();
  String? _selectedRelation;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String? _selectedSexe;
  File? _selectedImage;
  // late Future<List<Map<String, dynamic>>> _enfants;
  // Future pour les structures sanitaires
  // String _locationMessage = "Localisation non disponible";

  // Vérifier et demander l'autorisation
  // Future<void> _checkPermissions() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       setState(() {
  //         _locationMessage = "Permission refusée";
  //       });
  //       return;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     setState(() {
  //       _locationMessage = "Permission refusée de manière permanente";
  //     });
  //     return;
  //   }
  // }

  // // Obtenir la position actuelle
  // Future<void> _getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     setState(() {
  //       _locationMessage =
  //           "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _locationMessage = "Erreur : $e";
  //     });
  //   }
  // }

  late Future<List<Map<String, dynamic>>> _professions;
  int? _selectedProfessionId;
  late Future<List<Map<String, dynamic>>> _vulenerables;
  int? _selectedVulenerableId; // Variable pour stocker l'ID sélectionné

  @override
  void initState() {
    super.initState();
    // _checkPermissions();
    _vulenerables = _dbHelper.getVulenerable();
    _professions = _dbHelper.getProfession(); // Initialisation des enfants
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RECENSEMENT DE PDIS'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 77, 68, 206),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _savePersonne();
              _resetform();
            },
          ),
        ],
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
                  title: 'PROFILAGE',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _citNomController,
                        label: 'NOM',
                        hint: 'Entrez le nom',
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _citPostNomController,
                        label: 'POSTNOM',
                        hint: 'Entrez le postnom',
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _citPrenomController,
                        label: 'PRENOM',
                        hint: 'Entrez le prénom',
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 450,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'GENRE',
                            labelStyle: TextStyle(
                              color: Colors.black, // Couleur de l'étiquette
                              fontSize: 16,
                            ),
                            hintText: 'selectionnez le genre',
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
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                          ),
                          value: _selectedSexe, // Valeur initiale
                          items: <String>['Féminin', 'Masculin']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedSexe = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez sélectionner une option';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildDatePickerField(
                        controller: _citdatenaissController,
                        label: 'DATE DE NAISSANCE',
                        hint: 'Sélectionnez la date',
                        context: context,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                          controller: _citlieunaisController,
                          label: 'LIEU DE NAISSANCE',
                          hint: 'Entrez le lieu de naissance',
                          prefixIcon: Icon(Icons.home, color: Colors.black)),
                      const SizedBox(height: 15),
                      // _buildTextField(
                      //   controller: _relationController,
                      //   label: 'Rélation',
                      //   hint: 'rélation familliale',
                      // ),
                      SizedBox(
                        width: 450,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'RELATION',
                            labelStyle: TextStyle(
                              color: Colors.black, // Couleur de l'étiquette
                              fontSize: 16,
                            ),
                            hintText: 'selectionnez la relation',
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
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                          ),
                          value: _selectedRelation, // Valeur initiale
                          items: <String>['Père', 'Mère', 'Enfant']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRelation = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez sélectionner une option';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _professions,
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
                                    'kazlib']; // Supposons que strucNom soit le nom de la structure
                              }).toList(),
                              selectedItem: _selectedProfessionId != null
                                  ? snapshot.data!.firstWhere((s) =>
                                      s['localid'] ==
                                      _selectedProfessionId)['kazlib']
                                  : null,
                              dropdownBuilder: (context, selectedItem) {
                                return Text(selectedItem ??
                                    'Sélectionner une profession');
                              },
                              onChanged: (String? newValue) {
                                setState(() {
                                  // Mettez à jour la logique pour extraire l'ID de la structure en fonction du nom
                                  _selectedProfessionId = snapshot.data!
                                      .firstWhere(
                                          (s) => s['kazlib'] == newValue,
                                          orElse: () => {
                                                'localid': null
                                              })['localid'] as int?;
                                });
                              },
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                disabledItemFn: (item) =>
                                    item ==
                                    'Aucune profession', // Vous pouvez adapter cela selon vos besoins
                                fit: FlexFit.loose,
                              ),
                            );
                          } else {
                            return const Text('Aucune profession disponible');
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _vulenerables,
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
                                    'pdisnvulabr']; // Supposons que strucNom soit le nom de la structure
                              }).toList(),
                              selectedItem: _selectedVulenerableId != null
                                  ? snapshot.data!.firstWhere((s) =>
                                      s['localid'] ==
                                      _selectedVulenerableId)['pdisnvulabr']
                                  : null,
                              dropdownBuilder: (context, selectedItem) {
                                return Text(selectedItem ??
                                    'Sélectionner une vulnerabilté');
                              },
                              onChanged: (String? newValue) {
                                setState(() {
                                  // Mettez à jour la logique pour extraire l'ID de la structure en fonction du nom
                                  _selectedVulenerableId = snapshot.data!
                                      .firstWhere(
                                          (s) => s['pdisnvulabr'] == newValue,
                                          orElse: () => {
                                                'localid': null
                                              })['localid'] as int?;
                                });
                              },
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                disabledItemFn: (item) =>
                                    item ==
                                    'Aucune vulnerabilite', // Vous pouvez adapter cela selon vos besoins
                                fit: FlexFit.loose,
                              ),
                            );
                          } else {
                            return const Text('Aucune donnée disponible');
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                          width: 450,
                          child: Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _selectedImage != null
                                      ? Image.file(
                                          _selectedImage!,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 150,
                                          height: 150,
                                          color: Colors.grey[300],
                                          child:
                                              const Icon(Icons.image, size: 50),
                                        ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 28),
                                      backgroundColor: const Color.fromARGB(
                                          255, 77, 68, 206),
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: _pickImage,
                                    child: const Text('capturer'),
                                  ),
                                ])
                          ])),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: const Color.fromARGB(255, 77, 68, 206),
                  ),
                  onPressed: () async {
                    _savePersonne();
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                        return FormInformation();
                      }),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SUIVANT',
                        style: TextStyle(
                          color: Colors
                              .white, // Change la couleur ici, par exemple rouge
                          fontSize:
                              18, // Tu peux aussi spécifier la taille de la police
                        ),
                      ), // Texte du bouton
                      SizedBox(
                          width: 8), // Espacement entre le texte et l'icône
                      Icon(Icons.arrow_forward,
                          size: 18, color: Colors.white), // Icône flèche
                    ],
                  ),
                ),
              ],
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

  Widget _buildDatePickerField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required BuildContext context,
  }) {
    return SizedBox(
      width: 450,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.black, // Couleur de l'étiquette
              fontSize: 16),
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
          prefixIcon: Icon(Icons.calendar_view_day, color: Colors.black),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            setState(() {
              controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
            });
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez choisir une date';
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
      List<Map<String, dynamic>> menage = await _dbHelper.getDernierMenage();
      int? codemenage = menage.first['localid'];
      // List<Map<String, dynamic>> respo = await _dbHelper.getDernierPersonne();
      // int? codeRespo = respo.first['localid'];
      // int? codeRespoInc = (codeRespo ?? 0) + 1;
      // String? sexe = "F";
      // if (_selectedSexe == "Masculin") {
      //   sexe = "M";
      // }
      // List<Map<String, dynamic>> user = await _dbHelper.getDernierUser();
      // int? userId = user.first['userId'];
      await _dbHelper.insertPersonne({
        'nom': _citNomController.text,
        'postnom': _citPostNomController.text,
        'prenom': _citPrenomController.text,
        'sexe': _selectedSexe,
        'lieunais': _citlieunaisController.text,
        'datenaiss': _citdatenaissController.text,
        'photo': _selectedImage?.path,
        'vulenerabilite': _selectedVulenerableId,
        'relation': _selectedRelation,
        'profession': _selectedProfessionId,
        'codeMenage': codemenage,
      });

      // Vérifier si le widget est toujours monté avant d'utiliser Navigator ou showDialog
      if (!mounted) return;
    } catch (e) {
      // Gestion des erreurs si nécessaire
      print('Erreur lors de l\'enregistrement: $e');
    }
  }

  Future<void> _resetform() async {
    _formKey.currentState?.reset();
    _citNomController.clear();
    _citPostNomController.clear();
    _citPrenomController.clear();
    _citlieunaisController.clear();
    _citdatenaissController.clear();
    _observationController.clear();
    _professionController.clear();
  }
}
