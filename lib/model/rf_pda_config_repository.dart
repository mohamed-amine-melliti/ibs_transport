import 'package:sqflite/sqflite.dart';
import '../database/sossoldi_database.dart';
import 'rf_pda_config.dart';

class RfPdaConfigRepository {
  Future<Database> get database async {
    return await SossoldiDatabase.instance.database;
  }

  Future<RfPdaConfig?> getById(int id) async {
    final db = await database;
    final maps = await db.query(
      rfPdaConfigTable,
      columns: RfPdaConfigFields.allFields,
      where: '${RfPdaConfigFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return RfPdaConfig.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<RfPdaConfig>> getAll() async {
    final db = await database;
    final result = await db.query(rfPdaConfigTable);
    return result.map((json) => RfPdaConfig.fromJson(json)).toList();
  }

  Future<int> insert(RfPdaConfig config) async {
    final db = await database;
    return await db.insert(rfPdaConfigTable, config.toJson());
  }

  Future<int> update(RfPdaConfig config) async {
    final db = await database;
    return db.update(
      rfPdaConfigTable,
      config.toJson(),
      where: '${RfPdaConfigFields.id} = ?',
      whereArgs: [config.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      rfPdaConfigTable,
      where: '${RfPdaConfigFields.id} = ?',
      whereArgs: [id],
    );
  }
}