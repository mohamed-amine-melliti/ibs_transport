import 'package:sqflite/sqflite.dart';
import '../database/sossoldi_database.dart';
import 'tp_tourne.dart';

class TpTourneRepository {
  Future<Database> get database async {
    return await SossoldiDatabase.instance.database;
  }

  Future<TpTourne?> getById(String id) async {
    final db = await database;
    final maps = await db.query(
      tpTournesTable,
      columns: TpTourneFields.allFields,
      where: '${TpTourneFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TpTourne.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<TpTourne>> getAll() async {
    final db = await database;
    final result = await db.query(tpTournesTable);
    return result.map((json) => TpTourne.fromJson(json)).toList();
  }
  
  Future<List<TpTourne>> getByDate(DateTime date) async {
    final db = await database;
    final dateFormat = DateFormat('yyyy-MM-dd');
    final formattedDate = dateFormat.format(date);
    
    final result = await db.query(
      tpTournesTable,
      where: '${TpTourneFields.dateJourne} = ?',
      whereArgs: [formattedDate],
    );
    
    return result.map((json) => TpTourne.fromJson(json)).toList();
  }

  Future<int> insert(TpTourne tourne) async {
    final db = await database;
    return await db.insert(tpTournesTable, tourne.toJson());
  }

  Future<int> update(TpTourne tourne) async {
    final db = await database;
    return await db.update(
      tpTournesTable,
      tourne.toJson(),
      where: '${TpTourneFields.id} = ?',
      whereArgs: [tourne.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await database;
    return await db.delete(
      tpTournesTable,
      where: '${TpTourneFields.id} = ?',
      whereArgs: [id],
    );
  }
}