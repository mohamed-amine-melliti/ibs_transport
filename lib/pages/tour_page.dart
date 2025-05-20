import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../ui/device.dart';
import '../ui/widgets/default_card.dart';
import '../model/rf_pda_config_repository.dart';
import '../model/tp_tourne.dart';
import '../model/tp_passage.dart';
import '../model/tp_tourne_repository.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'tour_details_page.dart';
// Définition des statuts possibles pour une tournée
enum TourStatus { sortie, enCours, terminee }

// Extension pour obtenir le libellé du statut
extension TourStatusExtension on TourStatus {
  String get label {
    switch (this) {
      case TourStatus.sortie:
        return 'Sortie';
      case TourStatus.enCours:
        return 'En cours';
      case TourStatus.terminee:
        return 'Terminée';
    }
  }

  Color getColor(BuildContext context) {
    switch (this) {
      case TourStatus.sortie:
        return Colors.orange;
      case TourStatus.enCours:
        return Colors.blue;
      case TourStatus.terminee:
        return Colors.green;
    }
  }
}

// Provider pour la tournée actuelle (à remplacer par une vraie implémentation)
final currentTourProvider = StateProvider<TpTourne?>((ref) {
  // Return null initially, will be populated from API data
  return null;
});

class TourPage extends ConsumerStatefulWidget {
  const TourPage({super.key});

  @override
  ConsumerState<TourPage> createState() => _TourPageState();
}

class _TourPageState extends ConsumerState<TourPage> {
  bool _isSyncing = false;

  TpTourne tour = TpTourne();
  Map<String, dynamic>? _jsonData; // <-- Add this line
  final _centreFortController = TextEditingController();
  final _equipementController = TextEditingController();
  final _repository = RfPdaConfigRepository();
  @override
  void initState() {
    super.initState();
    _fetchOpeningData();
    _loadLastConfig();
  }

  Future<void> _fetchOpeningData() async {
    try {
      String username = 'admin';
      String password = 'smartup2025';
      String basicAuth ='Basic ' + base64Encode(utf8.encode('$username:$password'));

      final response = await http.post(
        Uri.parse('http://172.20.20.119:8082/ibs-api/tourne/ouvertureTourne'),
        headers: {'Authorization': basicAuth,'Content-Type': 'application/json'},
        body: jsonEncode({
          "centreFortId": "1",
          "dateJourne": "2025-01-22",
          "equipementId": "PDA200",
          "login": "admin",
          "password": ""
        }),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success']) {
          tour = TpTourne.fromJson(jsonData['data']);
          _jsonData = jsonData['data']; // <-- Store the decoded data
        } else {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('fdfd')),
            );
          });
        }
      } else {
        tour.chauffeur = response.statusCode.toString();
      }
    } catch (e) {
      tour.chauffeur = 'ddd';
    } finally {
      setState(() {});
    }
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
          //   _configId = lastConfig.id; // Stocker l'ID pour la mise à jour
        });
      }
    } catch (e) {
      // Gérer l'erreur si nécessaire
      print('Erreur lors du chargement de la configuration: $e');
    }
  }

  // Fonction pour synchroniser la tournée
  Future<void> _syncTour() async {
    setState(() {
      _isSyncing = true;
    });

    // Simuler une opération de synchronisation
    await Future.delayed(const Duration(seconds: 2));

    // Mettre à jour le statut après synchronisation
    if (mounted) {
      setState(() {
        _isSyncing = false;
      });

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tournée synchronisée avec succès')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
//    final tour = ref.watch(currentTourProvider);

    _fetchOpeningData();
    if (tour == null) {
      return const Center(child: Text('Aucune tournée en cours'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournée en cours'),
        actions: [
          IconButton(
            icon: _isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.sync),
            onPressed: _isSyncing ? null : _syncTour,
            tooltip: 'Synchroniser la tournée',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informations de la tournée
              DefaultCard(
                onTap: () {}, // Added required onTap parameter
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tournée ${tour.tourneId}',
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        ],
                      ),
                      const SizedBox(height: Sizes.md),
                      _buildInfoRow(
                          context, 'Véhicule', tour.fourgon.toString()),
                      _buildInfoRow(
                          context, 'Chauffeur', tour.chauffeur.toString()),
                      _buildInfoRow(
                          context, 'Convoyeurs', tour.convoyeur.toString()),
                      const Divider(height: Sizes.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Passages',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: Sizes.xs),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: '',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '0 / ${tour.nbrPassages.toString()}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.7),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TourDetailsPage(
                                    tour: tour,
                                    jsonData: _jsonData, // <-- Pass the additional info
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: const Text('Voir détails'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: Sizes.xl),

              // Section de progression
              DefaultCard(
                onTap: () {}, // Added required onTap callback
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progression',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: Sizes.md),
                      LinearProgressIndicator(
                        value: 1,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        color: Theme.of(context).colorScheme.primary,
                        minHeight: 10,
                        borderRadius:
                            BorderRadius.circular(Sizes.borderRadiusSmall),
                      ),
                      const SizedBox(height: Sizes.sm),
                      Text(
                        '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: Sizes.xl),

              const SizedBox(height: Sizes.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label :',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
