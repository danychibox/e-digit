import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'recensementdep.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<Map<String, int>> getPersonnesParSexe() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT sexe, COUNT(*) as count
    FROM personne
    GROUP BY sexe
  ''');

    Map<String, int> data = {};
    for (var row in result) {
      data[row['sexe'] as String] = row['count'] as int;
    }
    return data;
  }

  Future<Map<String, int>> getPersonnesParJour() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT date_inscri, COUNT(*) as count
    FROM personne
    GROUP BY date_inscri
  ''');

    Map<String, int> data = {};
    for (var row in result) {
      data[row['date_inscri'] as String] = row['count'] as int;
    }
    return data;
  }

  Future<Map<String, int>> getPersonnesParSyncStatus() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT is_synced, COUNT(*) as count
    FROM personne
    GROUP BY is_synced
  ''');

    Map<String, int> data = {};
    for (var row in result) {
      data[row['is_synced'] == 1 ? 'En ligne' : 'Hors ligne'] =
          row['count'] as int;
    }
    return data;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE personne(
        localid INTEGER PRIMARY KEY,
        nom TEXT,
        postnom TEXT,
        prenom TEXT,
        sexe TEXT,
        lieunais TEXT,
        datenaiss TEXT,
        photo TEXT,
        u_id INTEGER,
        date_inscri TEXT DEFAULT CURRENT_TIMESTAMP,
        vulenerabilite INTEGER,
        profession INTEGER,
        codeMenage INTEGER,
        relation TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE menage (
       localid INTEGER PRIMARY KEY,
        menanumparc TEXT,
        menasitua TEXT,
        avenue TEXT,
        nomrespo TEXT,
        phone TEXT,
        taillemenage INTEGER,
        localisation TEXT,
        zonesante INTEGER,
        qr_id INTEGER,
        u_id INTEGER,
        date_inscri TEXT DEFAULT CURRENT_TIMESTAMP,
        is_synced INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE infos (
        localid INTEGER PRIMARY KEY,
        nombreEnfant INTEGER,
        nbjour INTEGER,
        taillemen INTEGER,
        motif INTEGER,
        provenance TEXT,
        codeMenage INTEGER,
        respo INTEGER,
        is_synced INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE zonesante (
       localid INTEGER PRIMARY KEY,
        designation TEXT,
        zone INTEGER,
        is_synced INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE profession (
       localid INTEGER PRIMARY KEY,
        kazlib TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE vulenerable (
       localid INTEGER PRIMARY KEY,
        pdisnvulabr TEXT,
        pdisnvullib TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE  site (
        localid INTEGER PRIMARY KEY,
        qrlib VARCHAR,
        cm_id INTEGER,
        is_synced INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE motif (
      localid INTEGER PRIMARY KEY,
      libmotif TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE user (
      userId INTEGER PRIMARY KEY,
      username TEXT,
      mdp TEXT,
      nom_complet TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE login (
      id INTEGER PRIMARY KEY,
      userId INTEGER,
      username TEXT,
      nom_complet TEXT
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getNonSyncedPersonnes() async {
    final db = await database;
    return await db.query(
      'personne',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
  }

  Future<void> updatePersonneSyncedStatus(int personneId) async {
    final db = await database;
    await db.update(
      'personne',
      {'is_synced': 1},
      where: 'localid = ?',
      whereArgs: [personneId],
    );
  }

  Future<List<Map<String, dynamic>>> getNonSyncedMenages() async {
    final db = await database;
    return await db.query(
      'menage',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
  }

  Future<List<Map<String, dynamic>>> getNonSyncedInfos() async {
    final db = await database;
    return await db.query(
      'infos',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
  }

  Future<List<Map<String, dynamic>>> getSyncedInfos() async {
    final db = await database;
    return await db.query('infos');
  }

  Future<List<Map<String, dynamic>>> getNonSyncedSite() async {
    final db = await database;
    return await db.query(
      'site',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
  }

  Future<void> updateMenageSyncedStatus(int localid) async {
    final db = await database;
    await db.update(
      'menage',
      {'is_synced': 1},
      where: 'localid = ?',
      whereArgs: [localid],
    );
  }

  Future<void> updateInfoSyncedStatus(int infoId) async {
    final db = await database;
    await db.update(
      'info',
      {'is_synced': 1},
      where: 'localid = ?',
      whereArgs: [infoId],
    );
  }

  Future<void> updateSiteSyncedStatus(int siteId) async {
    final db = await database;
    await db.update(
      'site',
      {'is_synced': 1},
      where: 'localid = ?',
      whereArgs: [siteId],
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('user', user);
  }

  Future<int> insertLogin(Map<String, dynamic> login) async {
    final db = await database;
    return await db.insert('login', login);
  }

  Future<int> insertProfession(Map<String, dynamic> profession) async {
    final db = await database;
    return await db.insert('profession', profession);
  }

  Future<int> insertSite(Map<String, dynamic> site) async {
    final db = await database;
    return await db.insert('site', site);
  }

  Future<int> insertInfos(Map<String, dynamic> infos) async {
    final db = await database;
    return await db.insert('infos', infos);
  }

//fonction pour inserer les personnes
  Future<int> insertPersonne(Map<String, dynamic> personne) async {
    final db = await database;
    return await db.insert('personne', personne);
  }

  Future<int> insertMotif(Map<String, dynamic> motif) async {
    final db = await database;
    return await db.insert('motif', motif);
  }

  Future<int> insertVulenerable(Map<String, dynamic> vulenerable) async {
    final db = await database;
    return await db.insert('vulenerable', vulenerable);
  }

  Future<List<Map<String, dynamic>>> getMotif() async {
    final db = await database;
    return await db.query('motif');
  }

  Future<List<Map<String, dynamic>>> getVulenerable() async {
    final db = await database;
    return await db.query('vulenerable');
  }

  // fonction pour afficher les personnes
  Future<List<Map<String, dynamic>>> getPersonne() async {
    final db = await database;
    return await db.query('personne');
  }

  Future<Map<String, dynamic>?> getPersonById(int id) async {
    final db = await database;
    final result =
        await db.query('personne', where: 'localid = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getPersonne0() async {
    final db = await database;
    return await db.query(
      'personne',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
  }

  Future<List<Map<String, dynamic>>> getPersonne1() async {
    final db = await database;
    return await db.query(
      'personne',
      where: 'is_synced = ?',
      whereArgs: [1],
    );
  }

  // Fonction pour mettre à jour une personne dans la base de données
  Future<int> updatePersonne(int id, Map<String, dynamic> personne) async {
    final db = await database;
    return await db.update(
      'personne',
      personne,
      where: 'localid = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletePersonne(int id) async {
    final db = await database;
    return await db.delete(
      'personne',
      where: 'localid = ?',
      whereArgs: [id],
    );
  }

  // ********* Table Commune *********
  Future<int> insertMenage(Map<String, dynamic> menage) async {
    final db = await database;
    return await db.insert('menage', menage);
  }

  Future<int> insertZone(Map<String, dynamic> zonesante) async {
    final db = await database;
    return await db.insert('zonesante', zonesante);
  }

  Future<int> updateMenage(int id, Map<String, dynamic> menage) async {
    final db = await database;
    return await db.update(
      'menage',
      menage,
      where: 'localid = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMenage(int id) async {
    final db = await database;
    return await db.delete(
      'menage',
      where: 'localid = ?',
      whereArgs: [id],
    );
  }

  // ********* Table District *********

  Future<int> updateSite(int id, Map<String, dynamic> site) async {
    final db = await database;
    return await db.update(
      'site',
      site,
      where: 'localid = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteSite(int id) async {
    final db = await database;
    return await db.delete(
      'site',
      where: 'localid = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getDernierMenage() async {
    final db = await database;
    return await db.query('menage',
        columns: ['localid'], orderBy: 'localid DESC', limit: 1);
  }

  Future<List<Map<String, dynamic>>> getDernierPersonne() async {
    final db = await database;
    return await db.query('personne',
        columns: ['localid'], orderBy: 'localid DESC', limit: 1);
  }

  Future<List<Map<String, dynamic>>> getDernierPersonneMat() async {
    final db = await database;
    return await db.query('personne',
        columns: ['matricules'], orderBy: 'matricules DESC', limit: 1);
  }

  Future<List<Map<String, dynamic>>> getDernierMenages() async {
    final db = await database;
    return await db.query('menage',
        columns: ['localid'], orderBy: 'localid DESC', limit: 1);
  }

  Future<List<Map<String, dynamic>>> getDerniereSite() async {
    final db = await database;
    return await db.query('site',
        columns: ['localid'], orderBy: 'localid DESC', limit: 1);
  }

  Future<List<Map<String, dynamic>>> getDerniereSites() async {
    final db = await database;
    return await db.query('site', orderBy: 'localid DESC', limit: 1);
  }

  Future<List<Map<String, dynamic>>> getDernierUser() async {
    final db = await database;
    return await db.query('login',
        columns: ['userId'], orderBy: 'id DESC', limit: 1);
  }

  Future<Map<String, dynamic>?> getPersonneWithSiteAndOrigineById(
      int personneId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT 
      personne.nom,
      personne.postnom,
      personne.prenom, 
      personne.sexe,
      personne.lieunais, 
      personne.datenaiss,  
      personne.photo,
      site.qrlib,
      menage.avenue,
      menage.menanumparc,
      zonesante.designation
    FROM personne
    LEFT JOIN menage ON personne.codeMenage = menage.localid LEFT JOIN zonesante ON menage.zonesante=zonesante.localid LEFT JOIN infos ON personne.localid=infos.respo LEFT JOIN site on menage.qr_id=site.localid
    WHERE personne.localid = ?
  ''', [personneId]);

    // Si aucun résultat n'est trouvé, renvoie null
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getUser() async {
    final db = await database;
    return await db.query('user');
  }

  Future<List<Map<String, dynamic>>> getOrigine() async {
    final db = await database;
    return await db.query('origine');
  }

  Future<List<Map<String, dynamic>>> getProfession() async {
    final db = await database;
    return await db.query('profession');
  }

  Future<List<Map<String, dynamic>>> getsite() async {
    final db = await database;
    return await db.query('site');
  }

  Future<List<Map<String, dynamic>>> getzone() async {
    final db = await database;
    return await db.query('zonesante');
  }

  Future<Map<String, dynamic>?> verifierUtilisateur(
      String username, String password) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      'user',
      where: 'username = ? AND mdp = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      // Renvoie les informations de l'utilisateur, y compris l'ID
      return result.first;
    } else {
      // Aucun utilisateur trouvé
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> countUnsyncedPersonne() async {
    final db = await database;
    return await db
        .rawQuery('SELECT COUNT(*) as count FROM personne WHERE is_synced = 0');
  }

  Future<List<Map<String, dynamic>>> countSyncedPersonne() async {
    final db = await database;
    return await db
        .rawQuery('SELECT COUNT(*) as count FROM personne WHERE is_synced = 1');
  }

  Future<List<Map<String, dynamic>>> getPersonneAndInfosByMenage(
      int codeMenage) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT 
      p.localid AS personneId,
      p.nom AS nomPersonne,
      p.postnom AS postnomPersonne,
      p.prenom AS prenomPersonne,
      p.sexe as sexePersonne,
      i.localid AS infoId,
      i.nombreEnfant,
      i.nbjour,
      i.taillemen,
      i.motif,
      i.provenance
    FROM personne p
    INNER JOIN infos i ON p.codeMenage = i.codeMenage
    WHERE p.codeMenage = ?
  ''', [codeMenage]);
    return result;
  }

  Future<int> countDataByToday() async {
    final db = await database; // Obtenez l'instance de la base de données
    final today = DateTime.now()
        .toIso8601String()
        .split('T')[0]; // Obtenez la date du jour au format 'YYYY-MM-DD'

    final result = await db.rawQuery('''
    SELECT COUNT(*) as total
    FROM personne
    WHERE DATE(date_inscri) = ?
  ''', [today]);

    if (result.isNotEmpty) {
      return result.first['total'] as int;
    }
    return 0;
  }
}
