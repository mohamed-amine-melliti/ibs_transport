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
}