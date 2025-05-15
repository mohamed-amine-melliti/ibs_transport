import 'package:sqflite/sqflite.dart';
import '../database/sossoldi_database.dart';
import 'rm_remise_billet.dart';

class RmRemiseBilletRepository {
  Future<Database> get database async {
    return await SossoldiDatabase.instance.database;
  }

  Future<RmRemiseBillet?> getById(String referenceId, String passageId, String pointStopId) async {
    final db = await database;
    final maps = await db.query(
      rmRemiseBilletsTable,
      columns: RmRemiseBilletFields.allFields,
      where: '${RmRemiseBilletFields.referenceId} = ? AND ${RmRemiseBilletFields.passageId} = ? AND ${RmRemiseBilletFields.pointStopId} = ?',
      whereArgs: [referenceId, passageId, pointStopId],
    );

    if (maps.isNotEmpty) {
      return RmRemiseBillet.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<RmRemiseBillet>> getAll() async {
    final db = await database;
    final result = await db.query(rmRemiseBilletsTable);
    return result.map((json) => RmRemiseBillet.fromJson(json)).toList();
  }
  
  Future<List<RmRemiseBillet>> getByPassage(String passageId, String pointStopId) async {
    final db = await database;
    final result = await db.query(
      rmRemiseBilletsTable,
      where: '${RmRemiseBilletFields.passageId} = ? AND ${RmRemiseBilletFields.pointStopId} = ?',
      whereArgs: [passageId, pointStopId],
    );
    
    return result.map((json) => RmRemiseBillet.fromJson(json)).toList();
  }

  Future<int> insert(RmRemiseBillet remiseBillet) async {
    final db = await database;
    return await db.insert(rmRemiseBilletsTable, remiseBillet.toJson());
  }

  Future<int> update(RmRemiseBillet remiseBillet) async {
    final db = await database;
    return await db.update(
      rmRemiseBilletsTable,
      remiseBillet.toJson(),
      where: '${RmRemiseBilletFields.referenceId} = ? AND ${RmRemiseBilletFields.passageId} = ? AND ${RmRemiseBilletFields.pointStopId} = ?',
      whereArgs: [remiseBillet.referenceId, remiseBillet.passageId, remiseBillet.pointStopId],
    );
  }

  Future<int> delete(String referenceId, String passageId, String pointStopId) async {
    final db = await database;
    return await db.delete(
      rmRemiseBilletsTable,
      where: '${RmRemiseBilletFields.referenceId} = ? AND ${RmRemiseBilletFields.passageId} = ? AND ${RmRemiseBilletFields.pointStopId} = ?',
      whereArgs: [referenceId, passageId, pointStopId],
    );
  }
  
  Future<int> deleteByPassage(String passageId, String pointStopId) async {
    final db = await database;
    return await db.delete(
      rmRemiseBilletsTable,
      where: '${RmRemiseBilletFields.passageId} = ? AND ${RmRemiseBilletFields.pointStopId} = ?',
      whereArgs: [passageId, pointStopId],
    );
  }
}