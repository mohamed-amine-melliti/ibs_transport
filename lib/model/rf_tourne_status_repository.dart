import 'package:sqflite/sqflite.dart';
import '../database/sossoldi_database.dart';
import 'rf_tourne_status.dart';

class RfTourneStatusRepository {
  Future<Database> get database async {
    return await SossoldiDatabase.instance.database;
  }

  Future<RfTourneStatus?> getById(int id) async {
    final db = await database;
    final maps = await db.query(
      rfTourneStatusTable,
      columns: RfTourneStatusFields.allFields,
      where: '${RfTourneStatusFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return RfTourneStatus.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<RfTourneStatus>> getAll() async {
    final db = await database;
    final result = await db.query(rfTourneStatusTable);
    return result.map((json) => RfTourneStatus.fromJson(json)).toList();
  }

  Future<int> insert(RfTourneStatus status) async {
    final db = await database;
    return await db.insert(
      rfTourneStatusTable,
      status.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAll(List<RfTourneStatus> statuses) async {
    final db = await database;
    final batch = db.batch();
    
    for (var status in statuses) {
      batch.insert(
        rfTourneStatusTable,
        status.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete(rfTourneStatusTable);
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $rfTourneStatusTable (
        ${RfTourneStatusFields.id} INTEGER PRIMARY KEY,
        ${RfTourneStatusFields.libelle} TEXT NOT NULL
      )
    ''');
  }
}