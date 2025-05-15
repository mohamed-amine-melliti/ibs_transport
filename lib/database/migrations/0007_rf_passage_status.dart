import '../migration_base.dart';
import 'package:sqflite/sqflite.dart';

class RfPassageStatusMigration extends Migration {
  RfPassageStatusMigration() : super(version: 7, description: 'Create RF passage status table');
  @override
  int get version => 7; // Adjust this number based on your current migration version

  @override
  Future<void> up(Database db) async {
    // Create the table
    await db.execute('''
      CREATE TABLE RF_PASSAGE_STATUS (
        RF_STATUS_ID INTEGER NOT NULL,
        LIBELLE TEXT,
        PRIMARY KEY (RF_STATUS_ID)
      )
    ''');
    
    // Insert the values
    final batch = db.batch();
    
    batch.insert('RF_PASSAGE_STATUS', {
      'RF_STATUS_ID': 1,
      'LIBELLE': 'Encours'
    });
    
    batch.insert('RF_PASSAGE_STATUS', {
      'RF_STATUS_ID': 2,
      'LIBELLE': 'Realiser'
    });
    
    batch.insert('RF_PASSAGE_STATUS', {
      'RF_STATUS_ID': 3,
      'LIBELLE': 'Syncroniser'
    });
    
    await batch.commit();
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS RF_PASSAGE_STATUS');
  }
}