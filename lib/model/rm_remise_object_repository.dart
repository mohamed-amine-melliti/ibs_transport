import 'package:sqflite/sqflite.dart';
import '../database/sossoldi_database.dart';
import 'rm_remise_object.dart';

class RmRemiseObjectRepository {
  Future<Database> get database async {
    return await SossoldiDatabase.instance.database;
  }

  Future<RmRemiseObject?> getById(String referenceId, String passageId, String pointStopId) async {
    final db = await database;
    final maps = await db.query(
      rmRemiseObjectsTable,
      columns: RmRemiseObjectFields.allFields,
      where: '${RmRemiseObjectFields.referenceId} = ? AND ${RmRemiseObjectFields.passageId} = ? AND ${RmRemiseObjectFields.pointStopId} = ?',
      whereArgs: [referenceId, passageId, pointStopId],
    );

    if (maps.isNotEmpty) {
      return RmRemiseObject.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<RmRemiseObject>> getAll() async {
    final db = await database;
    final result = await db.query(rmRemiseObjectsTable);
    return result.map((json) => RmRemiseObject.fromJson(json)).toList();
  }
  
  Future<List<RmRemiseObject>> getByPassage(String passageId, String pointStopId) async {
    final db = await database;
    final result = await db.query(
      rmRemiseObjectsTable,
      where: '${RmRemiseObjectFields.passageId} = ? AND ${RmRemiseObjectFields.pointStopId} = ?',
      whereArgs: [passageId, pointStopId],
    );
    
    return result.map((json) => RmRemiseObject.fromJson(json)).toList();
  }
  
  Future<List<RmRemiseObject>> getByObjectId(String objectId) async {
    final db = await database;
    final result = await db.query(
      rmRemiseObjectsTable,
      where: '${RmRemiseObjectFields.objectId} = ?',
      whereArgs: [objectId],
    );
    
    return result.map((json) => RmRemiseObject.fromJson(json)).toList();
  }

  Future<int> insert(RmRemiseObject remiseObject) async {
    final db = await database;
    return await db.insert(rmRemiseObjectsTable, remiseObject.toJson());
  }

  Future<int> update(RmRemiseObject remiseObject) async {
    final db = await database;
    return await db.update(
      rmRemiseObjectsTable,
      remiseObject.toJson(),
      where: '${RmRemiseObjectFields.referenceId} = ? AND ${RmRemiseObjectFields.passageId} = ? AND ${RmRemiseObjectFields.pointStopId} = ?',
      whereArgs: [remiseObject.referenceId, remiseObject.passageId, remiseObject.pointStopId],
    );
  }

  Future<int> delete(String referenceId, String passageId, String pointStopId) async {
    final db = await database;
    return await db.delete(
      rmRemiseObjectsTable,
      where: '${RmRemiseObjectFields.referenceId} = ? AND ${RmRemiseObjectFields.passageId} = ? AND ${RmRemiseObjectFields.pointStopId} = ?',
      whereArgs: [referenceId, passageId, pointStopId],
    );
  }
  
  Future<int> deleteByPassage(String passageId, String pointStopId) async {
    final db = await database;
    return await db.delete(
      rmRemiseObjectsTable,
      where: '${RmRemiseObjectFields.passageId} = ? AND ${RmRemiseObjectFields.pointStopId} = ?',
      whereArgs: [passageId, pointStopId],
    );
  }
}