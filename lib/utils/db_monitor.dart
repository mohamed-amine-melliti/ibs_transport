import 'dart:async';
import 'package:flutter/material.dart';
import '../model/rf_pda_config.dart';
import '../model/rf_pda_config_repository.dart';

class DbMonitor {
  static final DbMonitor _instance = DbMonitor._internal();
  final RfPdaConfigRepository _repository = RfPdaConfigRepository();
  
  // Stream controller pour les données RF_PDA_CONFIGS
  final StreamController<List<RfPdaConfig>> _configsController = 
      StreamController<List<RfPdaConfig>>.broadcast();
  
  // Timer pour la mise à jour périodique
  Timer? _timer;
  
  // Getter pour le stream
  Stream<List<RfPdaConfig>> get configsStream => _configsController.stream;
  
  factory DbMonitor() {
    return _instance;
  }
  
  DbMonitor._internal() {
    // Initialiser le stream avec les données actuelles
    _refreshData();
  }
  
  // Démarrer la surveillance en temps réel
  void startMonitoring({Duration refreshInterval = const Duration(seconds: 1)}) {
    // Arrêter le timer existant s'il y en a un
    _timer?.cancel();
    
    // Créer un nouveau timer pour rafraîchir les données périodiquement
    _timer = Timer.periodic(refreshInterval, (_) => _refreshData());
  }
  
  // Arrêter la surveillance
  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }
  
  // Rafraîchir les données manuellement
  Future<void> refreshNow() async {
    await _refreshData();
  }
  
  // Méthode privée pour récupérer les données et les envoyer au stream
  Future<void> _refreshData() async {
    try {
      final configs = await _repository.getAll();
      _configsController.add(configs);
    } catch (e) {
      _configsController.addError(e);
    }
  }
  
  // Insérer ou mettre à jour une configuration
  Future<void> insertOrUpdateConfig(RfPdaConfig config) async {
    try {
      final existingConfig = await _repository.getById(config.id);
      
      if (existingConfig == null) {
        await _repository.insert(config);
      } else {
        await _repository.update(config);
      }
      
      // Rafraîchir les données après modification
      await _refreshData();
    } catch (e) {
      _configsController.addError(e);
    }
  }
  
  // Ne pas oublier de fermer le stream controller
  void dispose() {
    _timer?.cancel();
    _configsController.close();
  }
}