import 'dart:async';
import 'dart:developer' as dev;
import '../model/rf_pda_config.dart';
import '../model/rf_pda_config_repository.dart';

class DbPrinter {
  static final RfPdaConfigRepository _repository = RfPdaConfigRepository();
  static Timer? _timer;
  
  // Démarrer l'impression périodique
  static void startPrinting({Duration interval = const Duration(seconds: 2)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => printDbContents());
    dev.log('Démarrage de l\'impression de la base de données (intervalle: ${interval.inSeconds}s)');
  }
  
  // Arrêter l'impression
  static void stopPrinting() {
    _timer?.cancel();
    _timer = null;
    dev.log('Arrêt de l\'impression de la base de données');
  }
  
  // Imprimer le contenu de la base de données
  static Future<void> printDbContents() async {
    try {
      final configs = await _repository.getAll();
      
      dev.log('======= CONTENU DE LA TABLE RF_PDA_CONFIGS =======');
      dev.log('Nombre d\'enregistrements: ${configs.length}');
      
      if (configs.isEmpty) {
        dev.log('Aucun enregistrement trouvé');
      } else {
        for (var config in configs) {
          dev.log('-------------------------------------------');
          dev.log('ID: ${config.id}');
          dev.log('Centre Fort ID: ${config.centreFortId}');
          dev.log('PDA ID: ${config.pdaId}');
        }
      }
      
      dev.log('===============================================');
    } catch (e) {
      dev.log('Erreur lors de l\'impression de la base de données: $e', error: e);
    }
  }
}