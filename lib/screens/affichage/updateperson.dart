import 'package:flutter/material.dart';
import 'package:edigit/DatabaseHelper.dart';

class EditPersonPage extends StatefulWidget {
  final int localId; // ID de la personne à modifier

  const EditPersonPage({Key? key, required this.localId}) : super(key: key);

  @override
  _EditPersonPageState createState() => _EditPersonPageState();
}

class _EditPersonPageState extends State<EditPersonPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();

  // Controllers pour le formulaire
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _postnomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _lieunaisController = TextEditingController();
  final TextEditingController _datenaissController = TextEditingController();
  final TextEditingController _observationController = TextEditingController();
  final TextEditingController _provenanceController = TextEditingController();

  String? _selectedSexe;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPersonDetails();
  }

  Future<void> _loadPersonDetails() async {
    setState(() {
      _isLoading = true;
    });

    final person = await _dbHelper.getPersonById(widget.localId);
    if (person != null) {
      _nomController.text = person['nom'] ?? '';
      _postnomController.text = person['postnom'] ?? '';
      _prenomController.text = person['prenom'] ?? '';
      _lieunaisController.text = person['lieunais'] ?? '';
      _datenaissController.text = person['datenaiss'] ?? '';
      _datenaissController.text = person['provenance'] ?? '';
      _selectedSexe = person['sexe'];
      _observationController.text = person['observation'] ?? '';
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updatePerson() async {
    if (_formKey.currentState!.validate()) {
      await _dbHelper.updatePersonne(
        widget.localId,
        {
          'nom': _nomController.text,
          'postnom': _postnomController.text,
          'prenom': _prenomController.text,
          'sexe': _selectedSexe,
          'lieunais': _lieunaisController.text,
          'datenaiss': _datenaissController.text,
          'provenance': _provenanceController.text,
          'observation': _observationController.text,
        },
      );

      Navigator.pop(context, true);
    }
  }

  Widget _buildCard({required String title, required Widget content}) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Divider(
              thickness: 1.5,
              color: Colors.blueAccent.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est requis';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez sélectionner une option';
        }
        return null;
      },
    );
  }

  Widget _buildDatePickerField({
    required TextEditingController controller,
    required String label,
    required BuildContext context,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          controller.text = date.toIso8601String().split('T').first;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier la Personne'),
        backgroundColor: Color.fromARGB(255, 77, 68, 206),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildCard(
                        title: 'PROFILAGE',
                        content: Column(
                          children: [
                            _buildTextField(
                              controller: _nomController,
                              label: 'Nom',
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              controller: _postnomController,
                              label: 'Postnom',
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              controller: _prenomController,
                              label: 'Prénom',
                            ),
                            const SizedBox(height: 15),
                            _buildDropdownField(
                              label: 'Sexe',
                              items: ['Féminin', 'Masculin'],
                              value: _selectedSexe,
                              onChanged: (value) {
                                setState(() {
                                  _selectedSexe = value;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            _buildDatePickerField(
                              controller: _datenaissController,
                              label: 'Date de Naissance',
                              context: context,
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              controller: _lieunaisController,
                              label: 'Lieu de Naissance',
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              controller: _provenanceController,
                              label: 'provenance',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(260, 60),
                          textStyle: TextStyle(fontSize: 18),
                          backgroundColor: Color.fromARGB(255, 77, 68, 206),
                          foregroundColor: Color.fromARGB(255, 255, 255, 255),
                        ),
                        onPressed: _updatePerson,
                        child: const Text('Enregistrer'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
