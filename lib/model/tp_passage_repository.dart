import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import '../database/sossoldi_database.dart';
import 'tp_passage.dart';

class TpPassageRepository {
  Future<Database> get database async {
    return await SossoldiDatabase.instance.database;
  }

  Future<TpPassage?> getById(String passageId, String pointStopId) async {
    final db = await database;
    final maps = await db.query(
      tpPassagesTable,
      columns: TpPassageFields.allFields,
      where: '${TpPassageFields.passageId} = ? AND ${TpPassageFields.pointStopId} = ?',
      whereArgs: [passageId, pointStopId],
    );

    if (maps.isNotEmpty) {
      return TpPassage.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<TpPassage>> getAll() async {
    final db = await database;
    final result = await db.query(tpPassagesTable);
    return result.map((json) => TpPassage.fromJson(json)).toList();
  }
  
  Future<List<TpPassage>> getByTourneId(String tourneId) async {
    final db = await database;
    final result = await db.query(
      tpPassagesTable,
      where: '${TpPassageFields.tourneId} = ?',
      whereArgs: [tourneId],
      orderBy: '${TpPassageFields.ordre} ASC',
    );
    
    return result.map((json) => TpPassage.fromJson(json)).toList();
  }
  
  Future<List<TpPassage>> getByDate(DateTime date) async {
    final db = await database;
    final dateFormat = DateFormat('yyyy-MM-dd');
    final formattedDate = dateFormat.format(date);
    
    final result = await db.query(
      tpPassagesTable,
      where: '${TpPassageFields.dateJourne} = ?',
      whereArgs: [formattedDate],
    );
    
    return result.map((json) => TpPassage.fromJson(json)).toList();
  }

  Future<int> insert(TpPassage passage) async {
    final db = await database;
    return await db.insert(tpPassagesTable, passage.toJson());
  }

  Future<int> update(TpPassage passage) async {
    final db = await database;
    return await db.update(
      tpPassagesTable,
      passage.toJson(),
      where: '${TpPassageFields.passageId} = ? AND ${TpPassageFields.pointStopId} = ?',
      whereArgs: [passage.passageId, passage.pointStopId],
    );
  }

  Future<int> delete(String passageId, String pointStopId) async {
    final db = await database;
    return await db.delete(
      tpPassagesTable,
      where: '${TpPassageFields.passageId} = ? AND ${TpPassageFields.pointStopId} = ?',
      whereArgs: [passageId, pointStopId],
    );
  }
  
  Future<int> deleteByTourneId(String tourneId) async {
    final db = await database;
    return await db.delete(
      tpPassagesTable,
      where: '${TpPassageFields.tourneId} = ?',
      whereArgs: [tourneId],
    );
  }
}