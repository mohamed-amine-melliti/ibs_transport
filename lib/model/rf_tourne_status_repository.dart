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
}