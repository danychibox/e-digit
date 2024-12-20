import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:edigit/DatabaseHelper.dart'; // Importe ta classe DatabaseHelper

class EnfantStatsPage extends StatefulWidget {
  @override
  _EnfantStatsPageState createState() => _EnfantStatsPageState();
}

class _EnfantStatsPageState extends State<EnfantStatsPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Map<String, int> personnesParSexe = {};
  Map<String, int> personnesParSyncStatus = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final sexeData = await _dbHelper.getPersonnesParSexe();
    final syncStatusData = await _dbHelper.getPersonnesParSyncStatus();
    setState(() {
      personnesParSexe = sexeData;
      personnesParSyncStatus = syncStatusData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques de recensement'),
        backgroundColor: Color.fromARGB(255, 16, 72, 161),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatsRow(
                'personne par Sexe',
                _buildPieChartSexe(),
                _buildInfoSexe(),
              ),
              SizedBox(height: 40),
              _buildStatsRow(
                'personnes par Statut',
                _buildPieChartSyncStatus(),
                _buildInfoSyncStatus(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(String title, Widget chart, Widget info) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3), // Change the position of the shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4E5D75),
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 230,
                  child: chart,
                ),
              ),
              SizedBox(width: 50),
              Expanded(
                child: info,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSexe() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Répartition des personnes par sexe :',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4E5D75),
          ),
        ),
        SizedBox(height: 8),
        Text('Masculins: ${personnesParSexe['Masculin'] ?? 0}',
            style: TextStyle(fontSize: 16, color: Colors.blue)),
        Text('Féminins: ${personnesParSexe['Féminin'] ?? 0}',
            style: TextStyle(fontSize: 16, color: Colors.pink)),
      ],
    );
  }

  Widget _buildInfoSyncStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statut de synchronisation des personnes :',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4E5D75),
          ),
        ),
        SizedBox(height: 20),
        Text('En ligne: ${personnesParSyncStatus['En ligne'] ?? 0}',
            style: TextStyle(fontSize: 16, color: Colors.blue)),
        Text('Hors ligne: ${personnesParSyncStatus['Hors ligne'] ?? 0}',
            style: TextStyle(fontSize: 16, color: Colors.pink)),
      ],
    );
  }

  Widget _buildPieChartSexe() {
    return PieChart(
      PieChartData(
        sections: personnesParSexe.entries.map((entry) {
          return PieChartSectionData(
            color: entry.key == 'Masculin' ? Colors.blue : Colors.pink,
            value: entry.value.toDouble(),
            title: '${entry.value}',
            radius: 90,
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 4,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildPieChartSyncStatus() {
    return PieChart(
      PieChartData(
        sections: personnesParSyncStatus.entries.map((entry) {
          return PieChartSectionData(
            color: entry.key == 'En ligne' ? Colors.blue : Colors.pink,
            value: entry.value.toDouble(),
            title: '${entry.value}',
            radius: 90,
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 4,
        centerSpaceRadius: 40,
      ),
    );
  }
}
