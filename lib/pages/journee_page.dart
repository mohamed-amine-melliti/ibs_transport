import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../model/rf_pda_config_repository.dart';
import '../model/tp_tourne.dart';
import '../model/tp_passage.dart';
import '../model/tp_tourne_repository.dart';
import '../services/opening_service.dart';
class JourneePage extends StatefulWidget {
  const JourneePage({super.key});

  @override
  State<JourneePage> createState() => _JourneePageState();
}

class _JourneePageState extends State<JourneePage> {
  final _formKey = GlobalKey<FormState>();
  final _matriculeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  DateTime _selectedDate = DateTime.now();
  final _dateController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  final _centreFortController = TextEditingController();
  final _dateJourneController =
      TextEditingController(); // Controller for dateJourne
  final _equipementController = TextEditingController();
  final _loginController = TextEditingController(); // New controller for login
  final _repository = RfPdaConfigRepository();

  int? _configId;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
    _fetchOpeningData();
    _loadLastConfig();
  }
  final OpeningService _openingService = OpeningService();
  
  Future<void> _saveTourneData(TpTourne tourne) async {
    final tourneRepository = TpTourneRepository();
    final existingTourne = await tourneRepository.getById(tourne.tourneId.toString());
    if (existingTourne != null) {
      await tourneRepository.update(tourne);
    } else {
      await tourneRepository.insert(tourne);
    }
  }
  
  Future<void> _fetchOpeningData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _openingService.fetchOpeningData();
    
    if (result['success']) {
      final passage = result['passage'];
      setState(() {
        _centreFortController.text = passage.pointStopId ?? '';
        _matriculeController.text = passage.clientId ?? '';
        _dateJourneController.text = DateFormat('yyyy-MM-dd').format(passage.dateJourne);
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result['errorMessage'];
        _isLoading = false;
      });
    }
  }
  
  Future<void> _saveTourneDataToService(TpTourne tourne) async {
    await _openingService.saveTourneData(tourne);
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
    _dateJourneController.dispose();
    _equipementController.dispose();
    _loginController.dispose(); // Dispose the new controller

    _matriculeController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
      });
    }
  }

  void _validateAndSave() {
    if (_formKey.currentState!.validate()) {
      // Logique pour ouvrir une journée
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journée ouverte avec succès')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ouverture journée'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
        actions: [
          // Sign-out button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () {
              // Navigate back to login page
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date journée
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date journée',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner une date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Matricule
                TextFormField(
                  controller: _matriculeController,
                  decoration: const InputDecoration(
                    labelText: 'Matricule',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir votre matricule';
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
                    backgroundColor: Colors.blue, // Changed to blue
                    foregroundColor:
                        Colors.white, // Changed to white for better contrast
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

Future<void> _savePassageData(TpPassage passage) async {
  // Implement your database persistence logic here
  // Example:
  // final db = await DatabaseHelper.instance.database;
  // await db.insert('TP_PASSAGES', passage.toJson());
  
  // For now, just print the data
  print('Saving passage data: ${passage.toJson()}');
}
