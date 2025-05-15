import 'package:sqflite/sqflite.dart';
import '../database/sossoldi_database.dart';
import 'rp_reprise_object.dart';

class RpRepriseObjectRepository {
  Future<Database> get database async {
    return await SossoldiDatabase.instance.database;
  }

  Future<RpRepriseObject?> getById(String referenceId, String passageId, String tourneId, String pointStopId) async {
    final db = await database;
    final maps = await db.query(
      rpRepriseObjectsTable,
      columns: RpRepriseObjectFields.allFields,
      where: '${RpRepriseObjectFields.referenceId} = ? AND ${RpRepriseObjectFields.passageId} = ? AND ${RpRepriseObjectFields.tourneId} = ? AND ${RpRepriseObjectFields.pointStopId} = ?',
      whereArgs: [referenceId, passageId, tourneId, pointStopId],
    );

    if (maps.isNotEmpty) {
      return RpRepriseObject.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<RpRepriseObject>> getAll() async {
    final db = await database;
    final result = await db.query(rpRepriseObjectsTable);
    return result.map((json) => RpRepriseObject.fromJson(json)).toList();
  }
  
  Future<List<RpRepriseObject>> getByPassage(String passageId, String pointStopId) async {
    final db = await database;
    final result = await db.query(
      rpRepriseObjectsTable,
      where: '${RpRepriseObjectFields.passageId} = ? AND ${RpRepriseObjectFields.pointStopId} = ?',
      whereArgs: [passageId, pointStopId],
    );
    
    return result.map((json) => RpRepriseObject.fromJson(json)).toList();
  }
  
  Future<List<RpRepriseObject>> getByTourne(String tourneId) async {
    final db = await database;
    final result = await db.query(
      rpRepriseObjectsTable,
      where: '${RpRepriseObjectFields.tourneId} = ?',
      whereArgs: [tourneId],
    );
    
    return result.map((json) => RpRepriseObject.fromJson(json)).toList();
  }
  
  Future<List<RpRepriseObject>> getByObjectId(String objectId) async {
    final db = await database;
    final result = await db.query(
      rpRepriseObjectsTable,
      where: '${RpRepriseObjectFields.objectId} = ?',
      whereArgs: [objectId],
    );
    
    return result.map((json) => RpRepriseObject.fromJson(json)).toList();
  }

  Future<int> insert(RpRepriseObject repriseObject) async {
    final db = await database;
    return await db.insert(rpRepriseObjectsTable, repriseObject.toJson());
  }

  Future<int> update(RpRepriseObject repriseObject) async {
    final db = await database;
    return await db.update(
      rpRepriseObjectsTable,
      repriseObject.toJson(),
      where: '${RpRepriseObjectFields.referenceId} = ? AND ${RpRepriseObjectFields.passageId} = ? AND ${RpRepriseObjectFields.tourneId} = ? AND ${RpRepriseObjectFields.pointStopId} = ?',
      whereArgs: [repriseObject.referenceId, repriseObject.passageId, repriseObject.tourneId, repriseObject.pointStopId],
    );
  }

  Future<int> delete(String referenceId, String passageId, String tourneId, String pointStopId) async {
    final db = await database;
    return await db.delete(
      rpRepriseObjectsTable,
      where: '${RpRepriseObjectFields.referenceId} = ? AND ${RpRepriseObjectFields.passageId} = ? AND ${RpRepriseObjectFields.tourneId} = ? AND ${RpRepriseObjectFields.pointStopId} = ?',
      whereArgs: [referenceId, passageId, tourneId, pointStopId],
    );
  }
  
  Future<int> deleteByPassage(String passageId, String pointStopId) async {
    final db = await database;
    return await db.delete(
      rpRepriseObjectsTable,
      where: '${RpRepriseObjectFields.passageId} = ? AND ${RpRepriseObjectFields.pointStopId} = ?',
      whereArgs: [passageId, pointStopId],
    );
  }
  
  Future<int> deleteByTourne(String tourneId) async {
    final db = await database;
    return await db.delete(
      rpRepriseObjectsTable,
      where: '${RpRepriseObjectFields.tourneId} = ?',
      whereArgs: [tourneId],
    );
  }
}