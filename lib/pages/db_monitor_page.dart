import 'package:flutter/material.dart';
import '../model/rf_pda_config.dart';
import '../utils/db_monitor.dart';

class DbMonitorPage extends StatefulWidget {
  const DbMonitorPage({super.key});

  @override
  State<DbMonitorPage> createState() => _DbMonitorPageState();
}

class _DbMonitorPageState extends State<DbMonitorPage> {
  final DbMonitor _dbMonitor = DbMonitor();
  final TextEditingController _centreFortController = TextEditingController();
  final TextEditingController _pdaIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Démarrer la surveillance en temps réel
    _dbMonitor.startMonitoring();
  }

  @override
  void dispose() {
    _dbMonitor.stopMonitoring();
    _centreFortController.dispose();
    _pdaIdController.dispose();
    super.dispose();
  }

  // Insérer ou mettre à jour une configuration
  void _insertOrUpdateConfig() {
    if (_centreFortController.text.isNotEmpty && _pdaIdController.text.isNotEmpty) {
      final config = RfPdaConfig(
        id: 1, // Toujours utiliser 1 comme clé primaire
        centreFortId: _centreFortController.text,
        pdaId: _pdaIdController.text,
      );
      
      _dbMonitor.insertOrUpdateConfig(config);
      
      // Effacer les champs après insertion/mise à jour
      _centreFortController.clear();
      _pdaIdController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moniteur de base de données'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _dbMonitor.refreshNow(),
            tooltip: 'Rafraîchir manuellement',
          ),
        ],
      ),
      body: Column(
        children: [
          // Formulaire pour insérer/mettre à jour
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _centreFortController,
                  decoration: const InputDecoration(
                    labelText: 'Centre Fort ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _pdaIdController,
                  decoration: const InputDecoration(
                    labelText: 'PDA ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _insertOrUpdateConfig,
                  child: const Text('Insérer/Mettre à jour'),
                ),
              ],
            ),
          ),
          
          // Affichage des données en temps réel
          Expanded(
            child: StreamBuilder<List<RfPdaConfig>>(
              stream: _dbMonitor.configsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erreur: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                
                final configs = snapshot.data ?? [];
                
                if (configs.isEmpty) {
                  return const Center(
                    child: Text('Aucune configuration trouvée'),
                  );
                }
                
                return ListView.builder(
                  itemCount: configs.length,
                  itemBuilder: (context, index) {
                    final config = configs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                        title: Text('ID: ${config.id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Centre Fort: ${config.centreFortId}'),
                            Text('PDA ID: ${config.pdaId}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}