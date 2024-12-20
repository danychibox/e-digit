// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:edigit/Databasehelper.dart';
import 'package:edigit/screens/affichage/MenageList.dart';
import 'package:edigit/screens/affichage/accueil.dart';

class FormSite extends StatefulWidget {
  const FormSite({super.key});

  @override
  State<FormSite> createState() => _FormSiteState();
}

class _FormSiteState extends State<FormSite> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _NomPereController = TextEditingController();
  final TextEditingController _PrenomPereController = TextEditingController();
  final TextEditingController _PerelieunaisController = TextEditingController();
  final TextEditingController _PeredatenaissController =
      TextEditingController();
  final TextEditingController _AdresseController = TextEditingController();
  final TextEditingController _PostNomPereController = TextEditingController();
  final TextEditingController _DesignationController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

// Liste des quartiers

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RECENSEMENT DE PDIS'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 77, 68, 206),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Voir les enregistrements',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return MenageList();
                },
              ));
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    " SITE",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(83, 69, 69, 1),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 450,
                    child: TextFormField(
                      controller: _NomPereController,
                      decoration: InputDecoration(
                        labelText: 'TERRITOIRE OU VILLE',
                        labelStyle: TextStyle(
                          color: Colors.black, // Couleur de l'étiquette
                          fontSize: 16,
                        ),
                        hintText: 'Entrez territoire',
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
                        prefixIcon: Icon(Icons.person, color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer du texte';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 450,
                    child: TextFormField(
                      controller: _PostNomPereController,
                      decoration: InputDecoration(
                        labelText: 'COMMMUNE OU CHEFFERIE ',
                        labelStyle: TextStyle(
                          color: Colors.black, // Couleur de l'étiquette
                          fontSize: 16,
                        ),
                        hintText: 'Entrez la commnune ou la chefferie',
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
                        prefixIcon: Icon(Icons.person, color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer du texte';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 450,
                    child: TextFormField(
                      controller: _PrenomPereController,
                      decoration: InputDecoration(
                        labelText: 'QUARTIER OU VILLAGE ',
                        labelStyle: TextStyle(
                          color: Colors.black, // Couleur de l'étiquette
                          fontSize: 16,
                        ),
                        hintText: 'Entrez le quartier ou le village',
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
                        prefixIcon: Icon(Icons.person, color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer du texte';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 450,
                    child: TextFormField(
                      controller: _DesignationController,
                      decoration: InputDecoration(
                        labelText: 'NOM DU SITE ',
                        labelStyle: TextStyle(
                          color: Colors.black, // Couleur de l'étiquette
                          fontSize: 16,
                        ),
                        hintText: 'Entrez le nom du site',
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
                        prefixIcon: Icon(Icons.person, color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer du texte';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(260, 60),
                      textStyle: TextStyle(fontSize: 18),
                      backgroundColor: Color.fromARGB(255, 77, 68, 206),
                      foregroundColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveOrigine();
                      }
                    },
                    child: const Text("enregistrer"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveOrigine() async {
    Map<String, dynamic> site = {
      'territoireVille': _NomPereController.text,
      'communeChefferie': _PrenomPereController.text,
      'quartierVillage': _PerelieunaisController.text,
      'designation': _DesignationController.text,
    };
    await _dbHelper.insertSite(site);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Succès'),
          content: Text('origine enregistré avec succès.'),
          actions: <Widget>[
            TextButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                    return Accueil();
                  }),
                );
              },
            ),
          ],
        );
      },
    );

    _clearFields();
  }

  void _clearFields() {
    _NomPereController.clear();
    _PrenomPereController.clear();
    _PerelieunaisController.clear(); // Réinitialiser le quartier sélectionné
    _PeredatenaissController.clear();
    _AdresseController.clear();
    // _etatcivilController.clear();
  }
}
