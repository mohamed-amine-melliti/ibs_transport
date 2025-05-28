import 'package:sqflite/sqflite.dart';
import '../database/sossoldi_database.dart';
import 'rf_passage_resultat.dart';

class RfPassageResultatRepository {
  Future<Database> get database async {
    return await SossoldiDatabase.instance.database;
  }

  Future<RfPassageResultat?> getById(int id) async {
    final db = await database;
    final maps = await db.query(
      rfPassageResultatsTable,
      columns: RfPassageResultatFields.allFields,
      where: '${RfPassageResultatFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return RfPassageResultat.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<RfPassageResultat>> getAll() async {
    final db = await database;
    final result = await db.query(rfPassageResultatsTable);
    return result.map((json) => RfPassageResultat.fromJson(json)).toList();
  }

  Future<int> insert(RfPassageResultat resultat) async {
    final db = await database;
    return await db.insert(
      rfPassageResultatsTable,
      resultat.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAll(List<RfPassageResultat> resultats) async {
    final db = await database;
    final batch = db.batch();
    
    for (var resultat in resultats) {
      batch.insert(
        rfPassageResultatsTable,
        resultat.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete(rfPassageResultatsTable);
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $rfPassageResultatsTable (
        ${RfPassageResultatFields.id} INTEGER PRIMARY KEY,
        ${RfPassageResultatFields.libelle} TEXT NOT NULL
      )
    ''');
  }
}