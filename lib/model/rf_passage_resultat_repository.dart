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
}