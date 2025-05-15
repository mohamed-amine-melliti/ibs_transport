import '../migration_base.dart';
import 'package:sqflite/sqflite.dart';

class RfPassageResultatsMigration extends Migration {
  RfPassageResultatsMigration() : super(version: 6, description: 'Create RF_PASSAGE_RESULTATS table');
  @override
  int get version => 6; // Adjust this number based on your current migration version

  @override
  Future<void> up(Database db) async {
    // Create the table
    await db.execute('''
      CREATE TABLE RF_PASSAGE_RESULTATS (
        RF_RESULTAT_ID INTEGER NOT NULL,
        LIBELLE TEXT,
        PRIMARY KEY (RF_RESULTAT_ID)
      )
    ''');
    
    // Insert the values
    final batch = db.batch();
    
    batch.insert('RF_PASSAGE_RESULTATS', {
      'RF_RESULTAT_ID': 1,
      'LIBELLE': 'Réalisé'
    });
    
    batch.insert('RF_PASSAGE_RESULTATS', {
      'RF_RESULTAT_ID': 2,
      'LIBELLE': 'Néant+cachet'
    });
    
    batch.insert('RF_PASSAGE_RESULTATS', {
      'RF_RESULTAT_ID': 6,
      'LIBELLE': 'Refus par le client'
    });
    
    batch.insert('RF_PASSAGE_RESULTATS', {
      'RF_RESULTAT_ID': 7,
      'LIBELLE': 'Retard passage'
    });
    
    batch.insert('RF_PASSAGE_RESULTATS', {
      'RF_RESULTAT_ID': 8,
      'LIBELLE': 'Absence client'
    });
    
    batch.insert('RF_PASSAGE_RESULTATS', {
      'RF_RESULTAT_ID': 10,
      'LIBELLE': 'A vide client'
    });
    
    batch.insert('RF_PASSAGE_RESULTATS', {
      'RF_RESULTAT_ID': 11,
      'LIBELLE': 'A vide IBS'
    });
    
    await batch.commit();
  }

  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE IF EXISTS RF_PASSAGE_RESULTATS');
  }
}