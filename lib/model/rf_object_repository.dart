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
}