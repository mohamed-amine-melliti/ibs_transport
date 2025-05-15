import 'package:flutter/material.dart';

import '../model/rf_pda_config.dart';
import '../model/rf_pda_config_repository.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final _formKey = GlobalKey<FormState>();
  final _centreFortController = TextEditingController();
  final _equipementController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _repository = RfPdaConfigRepository();
  int? _configId;

  @override
  void initState() {
    super.initState();
    _loadLastConfig();
  }

  Future<void> _loadLastConfig() async {
    try {
      // Récupérer toutes les configurations
      final configs = await _repository.getAll();
      
      if (configs.isNotEmpty) {
        // Prendre la dernière configuration (supposée être la plus récente)
        final lastConfig = configs.last;
        setState(() {
          _centreFortController.text = lastConfig.centreFortId;
          _equipementController.text = lastConfig.pdaId;
          _configId = lastConfig.id; // Stocker l'ID pour la mise à jour
        });
      }
    } catch (e) {
      // Gérer l'erreur si nécessaire
      print('Erreur lors du chargement de la configuration: $e');
    }
  }

  @override
  void dispose() {
    _centreFortController.dispose();
    _equipementController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _validateAndSave() async {
    if (_formKey.currentState!.validate()) {
      // Vérification du mot de passe statique
      if (_passwordController.text == 'IBS*2025*') {
        try {
          // Récupérer toutes les configurations
          final configs = await _repository.getAll();
          
          // Créer l'objet de configuration avec les valeurs du formulaire
          RfPdaConfig config;
          
          if (configs.isEmpty) {
            // Si aucune configuration n'existe, créer une nouvelle avec ID=1
            config = RfPdaConfig(
              id: 1,
              centreFortId: _centreFortController.text,
              pdaId: _equipementController.text,
            );
            await _repository.insert(config);
          } else {
            // Sinon, mettre à jour la première configuration existante
            config = RfPdaConfig(
              id: configs.first.id, // Utiliser l'ID de la première configuration
              centreFortId: _centreFortController.text,
              pdaId: _equipementController.text,
            );
            await _repository.update(config);
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Configuration enregistrée avec succès')),
          );
          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${e.toString()}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mot de passe incorrect')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Centre fort ID
                TextFormField(
                  controller: _centreFortController,
                  decoration: const InputDecoration(
                    labelText: 'Centre fort ID',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir l\'ID du centre fort';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Equipement ID
                TextFormField(
                  controller: _equipementController,
                  decoration: const InputDecoration(
                    labelText: 'Equipement ID',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir l\'ID de l\'équipement';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Mot de passe
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir le mot de passe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),

                // Bouton Valider
                ElevatedButton(
                  onPressed: _validateAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'VALIDER',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
