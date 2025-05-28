import 'package:sqflite/sqflite.dart';
import '../database/sossoldi_database.dart';
import 'rf_object.dart';

class RfObjectRepository {
  Future<Database> get database async {
    return await SossoldiDatabase.instance.database;
  }

  Future<RfObject?> getById(String id) async {
    final db = await database;
    final maps = await db.query(
      rfObjectsTable,
      columns: RfObjectFields.allFields,
      where: '${RfObjectFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return RfObject.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<RfObject>> getAll() async {
    final db = await database;
    final result = await db.query(rfObjectsTable);
    return result.map((json) => RfObject.fromJson(json)).toList();
  }

  Future<int> insert(RfObject object) async {
    final db = await database;
    return await db.insert(
      rfObjectsTable,
      object.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAll(List<RfObject> objects) async {
    final db = await database;
    final batch = db.batch();
    
    for (var object in objects) {
      batch.insert(
        rfObjectsTable,
        object.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete(rfObjectsTable);
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $rfObjectsTable (
        ${RfObjectFields.id} TEXT PRIMARY KEY,
        ${RfObjectFields.libelle} TEXT NOT NULL
      )
    ''');
  }
}