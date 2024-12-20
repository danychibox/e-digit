// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_constructors_in_immutables

import 'package:edigit/screens/affichage/accueil.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:edigit/DatabaseHelper.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:edigit/screens/affichage/personne.dart';

class FormMenage extends StatefulWidget {
  FormMenage({super.key});

  @override
  State<FormMenage> createState() => _FormMenageState();
}

class _FormMenageState extends State<FormMenage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ciBlocController = TextEditingController();
  final TextEditingController _avenueController = TextEditingController();
  final TextEditingController _tailleController = TextEditingController();
  final TextEditingController _respoController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _menasitController = TextEditingController();
  String? _selectedSitua;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String _locationMessage = "Localisation non disponible";
  Future<void> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Permission refusée";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "Permission refusée de manière permanente";
      });
      return;
    }
  }

  // Obtenir la position actuelle
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _locationMessage = "${position.latitude}${position.longitude}";
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Erreur : $e";
      });
    }
  }

  late Future<List<Map<String, dynamic>>> _sites;
  int? _selectedSiteId;
  late Future<List<Map<String, dynamic>>> _zones;
  int? _selectedZoneId; // Variable pour stocker l'ID sélectionné

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    // _enfants = _dbHelper.getPersonne();
    _sites = _dbHelper.getsite();
    _zones = _dbHelper.getzone(); // Initialisation des enfants
  }

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
                    title: 'MENAGE D\'ACCUEIL',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _sites,
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
                                      'qrlib']; // Supposons que strucNom soit le nom de la structure
                                }).toList(),
                                selectedItem: _selectedSiteId != null
                                    ? snapshot.data!.firstWhere((s) =>
                                        s['localid'] ==
                                        _selectedSiteId)['qrlib']
                                    : null,
                                dropdownBuilder: (context, selectedItem) {
                                  return Text(selectedItem ??
                                      'Sélectionner un quartier');
                                },
                                onChanged: (String? newValue) {
                                  setState(() {
                                    // Mettez à jour la logique pour extraire l'ID de la structure en fonction du nom
                                    _selectedSiteId = snapshot.data!.firstWhere(
                                        (s) => s['qrlib'] == newValue,
                                        orElse: () => {
                                              'localid': null
                                            })['localid'] as int?;
                                  });
                                },
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  disabledItemFn: (item) =>
                                      item ==
                                      'Aucun quartier', // Vous pouvez adapter cela selon vos besoins
                                  fit: FlexFit.loose,
                                ),
                              );
                            } else {
                              return const Text('Aucun quartier disponible');
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _avenueController,
                          label: 'AVENUE',
                          hint: 'entrez le  nom de l\'avenue ',
                          prefixIcon: Icon(Icons.home, color: Colors.black),
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _ciBlocController,
                          label: 'NUMERO PARCELLAIRE',
                          hint: 'entrez le numero parcellaire',
                          prefixIcon: Icon(Icons.numbers, color: Colors.black),
                        ),
                        const SizedBox(height: 15),
                        // _buildTextField(
                        //     controller: _menasitController,
                        //     label: 'SITUATION',
                        //     hint: 'Situation du ménage'),
                        SizedBox(
                          width: 450,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'situation',
                              labelStyle: TextStyle(
                                color: Colors.black, // Couleur de l'étiquette
                                fontSize: 16,
                              ),
                              hintText: 'selectionnez la situation',
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
                              prefixIcon: Icon(Icons.home, color: Colors.black),
                            ),
                            value: _selectedSitua, // Valeur initiale
                            items: <String>['LOCATAIRE', 'PROPRIETAIRE']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSitua = newValue!;
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
                        // const SizedBox(height: 15),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _zones,
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
                                    snapshot.data!.map<String>((aire) {
                                  return aire[
                                      'designation']; // Supposons que strucNom soit le nom de la structure
                                }).toList(),
                                selectedItem: _selectedZoneId != null
                                    ? snapshot.data!.firstWhere((s) =>
                                        s['localid'] ==
                                        _selectedZoneId)['designation']
                                    : null,
                                dropdownBuilder: (context, selectedItem) {
                                  return Text(selectedItem ??
                                      'Sélectionner une aire de santé');
                                },
                                onChanged: (String? newValue) {
                                  setState(() {
                                    // Mettez à jour la logique pour extraire l'ID de la structure en fonction du nom
                                    _selectedZoneId = snapshot.data!.firstWhere(
                                        (s) => s['designation'] == newValue,
                                        orElse: () => {
                                              'localid': null
                                            })['localid'] as int?;
                                  });
                                },
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  disabledItemFn: (item) =>
                                      item ==
                                      'Aucune aire', // Vous pouvez adapter cela selon vos besoins
                                  fit: FlexFit.loose,
                                ),
                              );
                            } else {
                              return const Text('Aucune aire disponible');
                            }
                          },
                        ),

                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _respoController,
                          label: 'RESPONSABLE',
                          hint: 'nom complet',
                          prefixIcon: Icon(Icons.person, color: Colors.black),
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
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'TELEPHONE',
                              counterText: '',
                              labelStyle: TextStyle(
                                color: Colors.black, // Couleur de l'étiquette
                                fontSize: 16,
                              ),
                              hintText: 'Entrez le numéro de telephone',
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
                              prefixIcon: Icon(Icons.phone_in_talk,
                                  color: Colors.black),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un numéro de téléphone';
                              }
                              if (value.length != 10) {
                                return "Le champ doit contenir exactement 10 chiffres";
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: _getCurrentLocation,
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: const Color.fromARGB(255, 77, 68, 206),
                    ),
                    child: Text(
                      'Obtenir la localisation',
                      style: TextStyle(
                        color: Colors
                            .white, // Change la couleur ici, par exemple rouge
                        fontSize:
                            18, // Tu peux aussi spécifier la taille de la police
                      ),
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
                        await _saveMenage();
                        Navigator.push(context, MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          return FormPersonne();
                        }));
                      }
                    },
                    child: const Text(
                      'SUIVANT',
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

  Future<void> _saveMenage() async {
    try {
      await _dbHelper.insertMenage({
        'avenue': _avenueController.text,
        'qr_id': _selectedSiteId,
        'menanumparc': _ciBlocController.text,
        // 'observation': _observationController.text,
        // 'nbjour': _nbjourController.text,
        'menasitua': _selectedSitua,
        'nomrespo': _respoController.text,
        'taillemenage': _tailleController.text,
        'localisation': _locationMessage,
        'phone': _phoneController.text,
        'zonesante': _selectedZoneId
        // 'airesante': _aireController.text
      });

      // Vérifier si le widget est toujours monté avant d'utiliser Navigator ou showDialog
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
          return FormPersonne();
        }),
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
