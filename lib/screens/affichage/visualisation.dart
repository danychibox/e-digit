// ignore_for_file: unused_field, prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:edigit/DatabaseHelper.dart';

class EnfantDetailsScreen extends StatefulWidget {
  final int personneId;
  EnfantDetailsScreen({required this.personneId});

  @override
  _EnfantDetailsScreenState createState() => _EnfantDetailsScreenState();
}

class _EnfantDetailsScreenState extends State<EnfantDetailsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isSearching = false;
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du recensé',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        elevation: 5, // Ajoute une légère ombre à l'AppBar
        backgroundColor: Color.fromARGB(255, 77, 68, 206), // Couleur principale
        foregroundColor: Colors.white, // Couleur du texte dans l'AppBar
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _dbHelper.getPersonneWithSiteAndOrigineById(widget.personneId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Aucune personne trouvé.'));
          } else {
            final personneData = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCard(
                    title: 'Détails du recensé',
                    content: Column(
                      children: [
                        _buildDetailRow('Nom complet ',
                            '${personneData['nom']} ${personneData['postnom']} ${personneData['prenom']}'),
                        _buildDetailRow('Sexe', personneData['sexe']),
                        _buildDetailRow(
                            'Lieu de naissance', personneData['lieunais']),
                        _buildDetailRow(
                            'Date de naissance', personneData['datenaiss']),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildCard(
                    title: 'provenance',
                    content: Column(
                      children: [
                        _buildDetailRow('lieu de provenance ',
                            '${personneData['provenance']}'),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildCard(
                    title: 'Addresse d\'accueil',
                    content: Column(
                      children: [
                        _buildDetailRow('quartier ', personneData['qrlib']),
                        _buildDetailRow('avenue', personneData['avenue']),
                        _buildDetailRow('numéro', personneData['menanumparc']),
                        _buildDetailRow(
                            'aire de santé ', personneData['designation']),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Fonction qui construit une carte avec un titre et un contenu
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

  // Fonction pour afficher une ligne de détail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
