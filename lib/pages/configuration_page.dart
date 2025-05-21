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
  final _locationController = TextEditingController(); // NEW
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
      final configs = await _repository.getAll();
      if (configs.isNotEmpty) {
        final lastConfig = configs.last;
        setState(() {
          _centreFortController.text = lastConfig.centreFortId;
          _equipementController.text = lastConfig.pdaId;
          _locationController.text = lastConfig.url ?? ''; // NEW
          _configId = lastConfig.id;
        });
      }
    } catch (e) {
      print('Erreur lors du chargement de la configuration: $e');
    }
  }

  @override
  void dispose() {
    _centreFortController.dispose();
    _equipementController.dispose();
    _locationController.dispose(); // NEW
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _validateAndSave() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text == 'IBS*2025*') {
        try {
          final configs = await _repository.getAll();

          RfPdaConfig config;

          if (configs.isEmpty) {
            config = RfPdaConfig(
              id: 1,
              centreFortId: _centreFortController.text,
              pdaId: _equipementController.text,
              url: _locationController.text, // NEW
            );
            await _repository.insert(config);
          } else {
            config = RfPdaConfig(
              id: configs.first.id,
              centreFortId: _centreFortController.text,
              pdaId: _equipementController.text,
              url: _locationController.text, // NEW
            );
            await _repository.update(config);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Configuration enregistrée avec succès')),
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

                // NEW: Location
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir un URL';
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
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
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
