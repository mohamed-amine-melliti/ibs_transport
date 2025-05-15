import '../migration_base.dart';
import 'package:sqflite/sqflite.dart';

class RfObjectsMigration extends Migration {
  RfObjectsMigration() : super(version: 9, description: 'Create RF_OBJECTS table');
  @override
  int get version => 9; // Adjust this number based on your current migration version

  @override
  Future<void> up(Database db) async {
    // Create the table
    await db.execute('''
      CREATE TABLE RF_OBJECTS (
        RF_OBJECT_ID TEXT NOT NULL,
        LIBELLE TEXT,
        PRIMARY KEY (RF_OBJECT_ID)
      )
    ''');
    
    // Insert the values
    final batch = db.batch();
    
    batch.insert('RF_OBJECTS', {
      'RF_OBJECT_ID': 'F_5DT',
      'LIBELLE': 'Monnaie 5'
    });
    
    batch.insert('RF_OBJECTS', {
      'RF_OBJECT_ID': 'F_BDT',
      'LIBELLE': 'Billet'
    });
    
    batch.insert('RF_OBJECTS', {
      'RF_OBJECT_ID': 'F_MDT',
      'LIBELLE': 'Monnaie'
    });
    
    batch.insert('RF_OBJECTS', {
      'RF_OBJECT_ID': 'O_BDT',
      'LIBELLE': 'Billet divers'
    });
    
    batch.insert('RF_OBJECTS', {
      'RF_OBJECT_ID': 'O_DEV',
      'LIBELLE': 'Devise'
    });
    
    batch.insert('RF_OBJECTS', {
      'RF_OBJECT_ID': 'O_VAL',
      'LIBELLE': 'Valeur'
    });
    
    batch.insert('RF_OBJECTS', {
      'RF_OBJECT_ID': 'O_COL',
      'LIBELLE': 'Colis'
    });
    
    await batch.commit();
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS RF_OBJECTS');
  }
}