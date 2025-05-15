import 'package:sqflite/sqflite.dart';
import '../database/sossoldi_database.dart';
import 'rm_remise_monnaie.dart';

class RmRemiseMonnaieRepository {
  Future<Database> get database async {
    return await SossoldiDatabase.instance.database;
  }

  Future<RmRemiseMonnaie?> getById(String referenceId, String passageId, String pointStopId) async {
    final db = await database;
    final maps = await db.query(
      rmRemiseMonnaiesTable,
      columns: RmRemiseMonnaieFields.allFields,
      where: '${RmRemiseMonnaieFields.referenceId} = ? AND ${RmRemiseMonnaieFields.passageId} = ? AND ${RmRemiseMonnaieFields.pointStopId} = ?',
      whereArgs: [referenceId, passageId, pointStopId],
    );

    if (maps.isNotEmpty) {
      return RmRemiseMonnaie.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<RmRemiseMonnaie>> getAll() async {
    final db = await database;
    final result = await db.query(rmRemiseMonnaiesTable);
    return result.map((json) => RmRemiseMonnaie.fromJson(json)).toList();
  }
  
  Future<List<RmRemiseMonnaie>> getByPassage(String passageId, String pointStopId) async {
    final db = await database;
    final result = await db.query(
      rmRemiseMonnaiesTable,
      where: '${RmRemiseMonnaieFields.passageId} = ? AND ${RmRemiseMonnaieFields.pointStopId} = ?',
      whereArgs: [passageId, pointStopId],
    );
    
    return result.map((json) => RmRemiseMonnaie.fromJson(json)).toList();
  }

  Future<int> insert(RmRemiseMonnaie remiseMonnaie) async {
    final db = await database;
    return await db.insert(rmRemiseMonnaiesTable, remiseMonnaie.toJson());
  }

  Future<int> update(RmRemiseMonnaie remiseMonnaie) async {
    final db = await database;
    return await db.update(
      rmRemiseMonnaiesTable,
      remiseMonnaie.toJson(),
      where: '${RmRemiseMonnaieFields.referenceId} = ? AND ${RmRemiseMonnaieFields.passageId} = ? AND ${RmRemiseMonnaieFields.pointStopId} = ?',
      whereArgs: [remiseMonnaie.referenceId, remiseMonnaie.passageId, remiseMonnaie.pointStopId],
    );
  }

  Future<int> delete(String referenceId, String passageId, String pointStopId) async {
    final db = await database;
    return await db.delete(
      rmRemiseMonnaiesTable,
      where: '${RmRemiseMonnaieFields.referenceId} = ? AND ${RmRemiseMonnaieFields.passageId} = ? AND ${RmRemiseMonnaieFields.pointStopId} = ?',
      whereArgs: [referenceId, passageId, pointStopId],
    );
  }
  
  Future<int> deleteByPassage(String passageId, String pointStopId) async {
    final db = await database;
    return await db.delete(
      rmRemiseMonnaiesTable,
      where: '${RmRemiseMonnaieFields.passageId} = ? AND ${RmRemiseMonnaieFields.pointStopId} = ?',
      whereArgs: [passageId, pointStopId],
    );
  }
}