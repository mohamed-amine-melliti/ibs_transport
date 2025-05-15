import '../migration_base.dart';
import 'package:sqflite/sqflite.dart';

class RfTourneStatusMigration extends Migration {
  RfTourneStatusMigration() : super(version: 8, description: 'Create RF_TOURNE_STATUS table');
  @override
  int get version => 8; // Adjust this number based on your current migration version

  @override
  Future<void> up(Database db) async {
    // Create the table
    await db.execute('''
      CREATE TABLE RF_TOURNE_STATUS (
        RF_STATUS_ID INTEGER NOT NULL,
        LIBELLE TEXT,
        PRIMARY KEY (RF_STATUS_ID)
      )
    ''');
    
    // Insert the values
    final batch = db.batch();
    
    batch.insert('RF_TOURNE_STATUS', {
      'RF_STATUS_ID': 1,
      'LIBELLE': 'En cours'
    });
    
    batch.insert('RF_TOURNE_STATUS', {
      'RF_STATUS_ID': 2,
      'LIBELLE': 'Terminée'
    });
    
    batch.insert('RF_TOURNE_STATUS', {
      'RF_STATUS_ID': 3,
      'LIBELLE': 'Clolure'
    });
    
    await batch.commit();
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS RF_TOURNE_STATUS');
  }
}