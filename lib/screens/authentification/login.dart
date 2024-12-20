// ignore_for_file: non_constant_identifier_names, prefer_final_fields, prefer_const_constructors, use_build_context_synchronously

import 'package:edigit/screens/affichage/nonsynchroniser.dart';
import 'package:flutter/material.dart';
import 'package:edigit/DatabaseHelper.dart';
// import 'package:edigit/screens/affichage/syncAll.dart';
import 'dart:convert';
// import 'package:recensement_app/screens/affichage/nonsynchroniser.dart';
import 'package:crypto/crypto.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Déclare le GlobalKey pour le formulaire
  final _formKey = GlobalKey<FormState>();

  // Les contrôleurs pour les champs de texte

  TextEditingController _emailController = TextEditingController();
  TextEditingController _mdpController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String crypterSha1(String password) {
    final bytes = utf8.encode(password);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }

  Future<void> _Login() async {
    String username = _emailController.text;
    String mdp = _mdpController.text;
    String password = crypterSha1(mdp);

    Map<String, dynamic>? utilisateur =
        await _dbHelper.verifierUtilisateur(username, password);

    if (utilisateur != null) {
      // Connexion réussie, récupère l'ID de l'utilisateur
      int userId = utilisateur['userId'];
      String user = utilisateur['username'];
      await _dbHelper.insertLogin({
        'username': user,
        'userId': userId,
      });

      // Rediriger vers la page d'accueil avec l'ID de l'utilisateur
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return UnsyncedPersonsPage(); // Passer userId ici
          },
        ),
      );
    } else {
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nom d\'utilisateur ou mot de passe incorrect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RECENSEMENT DE PDIS'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 77, 68, 206),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _formKey, // Associe le formulaire avec le GlobalKey
              child: Column(
                children: [
                  Text(
                    "CONNEXION",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 450,
                    child: TextFormField(
                      // Lier le contrôleur
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Utilisateur',
                        labelStyle: TextStyle(
                          color: Colors.black, // Couleur de l'étiquette
                          fontSize: 16,
                        ),
                        hintText: 'Entrez votre nom d\'utilisateur',
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
                          return 'Veuillez entrer votre nom d\'utilisateur';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 450,
                    child: TextFormField(
                      // Lier le contrôleur
                      controller: _mdpController,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        hintText: 'Entrez votre mot de passe',
                        hintStyle: TextStyle(color: Colors.blue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
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
                            color: Color.fromARGB(255, 0, 0, 0),
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock, color: Colors.black),
                      ),
                      obscureText: true, // Masquer le mot de passe
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(280, 60),
                        textStyle: TextStyle(fontSize: 28),
                        backgroundColor: Color.fromARGB(255, 77, 68, 206),
                        foregroundColor: Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {
                      _Login();
                    },
                    child: const Text("Se connecter"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveEnfant() async {
    // Obtenir les données du père, de la mère et du déclarant
  }
}
