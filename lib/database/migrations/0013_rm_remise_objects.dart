import '../migration_base.dart';
import 'package:sqflite/sqflite.dart';

class RmRemiseObjectsMigration extends Migration {
  RmRemiseObjectsMigration() : super(version: 13, description: 'Create RM_REMISE_OBJECTS table');
  @override
  int get version => 13; // Adjust this number based on your current migration version

  @override
  Future<void> up(Database db) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
    
    // Create the table
    await db.execute('''
      CREATE TABLE RM_REMISE_OBJECTS (
        RM_REFERENCE_ID TEXT NOT NULL,
        TP_PASSAGE_ID TEXT NOT NULL,
        TR_POINT_STOP_ID TEXT NOT NULL,
        RF_OBJECT_ID TEXT,
        IS_RETOUR INTEGER,
        PRIMARY KEY (RM_REFERENCE_ID, TP_PASSAGE_ID, TR_POINT_STOP_ID),
        FOREIGN KEY (TP_PASSAGE_ID, TR_POINT_STOP_ID) 
          REFERENCES TP_PASSAGES (TP_PASSAGE_ID, TR_POINT_STOP_ID) 
          ON DELETE RESTRICT ON UPDATE RESTRICT,
        FOREIGN KEY (RF_OBJECT_ID) 
          REFERENCES RF_OBJECTS (RF_OBJECT_ID) 
          ON DELETE RESTRICT ON UPDATE RESTRICT
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS RM_REMISE_OBJECTS');
  }
}