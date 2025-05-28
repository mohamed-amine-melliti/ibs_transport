import 'package:sqflite/sqflite.dart';
import '../database/sossoldi_database.dart';
import 'rf_passage_status.dart';

class RfPassageStatusRepository {
  Future<Database> get database async {
    return await SossoldiDatabase.instance.database;
  }

  Future<RfPassageStatus?> getById(int id) async {
    final db = await database;
    final maps = await db.query(
      rfPassageStatusTable,
      columns: RfPassageStatusFields.allFields,
      where: '${RfPassageStatusFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return RfPassageStatus.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<RfPassageStatus>> getAll() async {
    final db = await database;
    final result = await db.query(rfPassageStatusTable);
    return result.map((json) => RfPassageStatus.fromJson(json)).toList();
  }

  Future<int> insert(RfPassageStatus status) async {
    final db = await database;
    return await db.insert(
      rfPassageStatusTable,
      status.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAll(List<RfPassageStatus> statuses) async {
    final db = await database;
    final batch = db.batch();
    
    for (var status in statuses) {
      batch.insert(
        rfPassageStatusTable,
        status.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete(rfPassageStatusTable);
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $rfPassageStatusTable (
        ${RfPassageStatusFields.id} INTEGER PRIMARY KEY,
        ${RfPassageStatusFields.libelle} TEXT NOT NULL
      )
    ''');
  }
}