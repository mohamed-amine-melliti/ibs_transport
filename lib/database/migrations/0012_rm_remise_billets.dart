import '../migration_base.dart';
import 'package:sqflite/sqflite.dart';

class RmRemiseBilletsMigration extends Migration {
  RmRemiseBilletsMigration() : super(version: 12, description: 'Create RM_REMISE_BILLETS table');
  @override
  int get version => 12; // Adjust this number based on your current migration version

  @override
  Future<void> up(Database db) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
    
    // Create the table
    await db.execute('''
      CREATE TABLE RM_REMISE_BILLETS (
        RM_REFERENCE_ID TEXT NOT NULL,
        TP_PASSAGE_ID TEXT NOT NULL,
        TR_POINT_STOP_ID TEXT NOT NULL,
        TYPE1 TEXT,
        MONTANT1 REAL,
        TYPE2 TEXT,
        MONTANT2 REAL,
        MONTANT_GLOBAL REAL,
        PRIMARY KEY (RM_REFERENCE_ID, TP_PASSAGE_ID, TR_POINT_STOP_ID),
        FOREIGN KEY (TP_PASSAGE_ID, TR_POINT_STOP_ID) 
          REFERENCES TP_PASSAGES (TP_PASSAGE_ID, TR_POINT_STOP_ID) 
          ON DELETE RESTRICT ON UPDATE RESTRICT
      )
    ''');
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS RM_REMISE_BILLETS');
  }
}