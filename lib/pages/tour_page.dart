import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ui/device.dart';
import '../ui/widgets/default_card.dart';

// Définition des statuts possibles pour une tournée
enum TourStatus {
  sortie,
  enCours,
  terminee
}

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

// Modèle de données pour une tournée
class Tour {
  final String id;
  final TourStatus status;
  final String vehicle;
  final String driver;
  final List<String> convoyeurs;
  final int completedPassages;
  final int totalPassages;
  
  Tour({
    required this.id,
    required this.status,
    required this.vehicle,
    required this.driver,
    required this.convoyeurs,
    required this.completedPassages,
    required this.totalPassages,
  });
}

// Provider pour la tournée actuelle (à remplacer par une vraie implémentation)
final currentTourProvider = StateProvider<Tour?>((ref) {
  // Exemple de données pour démonstration
  return Tour(
    id: 'T-12345',
    status: TourStatus.enCours,
    vehicle: 'Camion 42',
    driver: 'Jean Dupont',
    convoyeurs: ['Marie Martin', 'Pierre Durand'],
    completedPassages: 8,
    totalPassages: 15,
  );
});

class TourPage extends ConsumerStatefulWidget {
  const TourPage({super.key});

  @override
  ConsumerState<TourPage> createState() => _TourPageState();
}

class _TourPageState extends ConsumerState<TourPage> {
  bool _isSyncing = false;
  
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
  
  // Fonction pour valider le retour de tournée
  void _validateTourReturn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Valider le retour de tournée'),
        content: const Text('Êtes-vous sûr de vouloir valider le retour de cette tournée ? Cette action mettra à jour son statut dans l\'application métier.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // Logique de validation du retour
              Navigator.pop(context);
              
              // Mettre à jour le statut de la tournée
              final tour = ref.read(currentTourProvider);
              if (tour != null) {
                ref.read(currentTourProvider.notifier).state = Tour(
                  id: tour.id,
                  status: TourStatus.terminee,
                  vehicle: tour.vehicle,
                  driver: tour.driver,
                  convoyeurs: tour.convoyeurs,
                  completedPassages: tour.totalPassages, // Tous les passages sont complétés
                  totalPassages: tour.totalPassages,
                );
              }
              
              // Afficher un message de confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Retour de tournée validé')),
              );
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tour = ref.watch(currentTourProvider);
    
    if (tour == null) {
      return const Center(child: Text('Aucune tournée en cours'));
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournée en cours'),
        actions: [
          IconButton(
            icon: _isSyncing 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
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
                            'Tournée ${tour.id}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: Sizes.sm, vertical: Sizes.xs),
                            decoration: BoxDecoration(
                              color: tour.status.getColor(context).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(Sizes.borderRadiusSmall),
                            ),
                            child: Text(
                              tour.status.label,
                              style: TextStyle(
                                color: tour.status.getColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Sizes.md),
                      _buildInfoRow(context, 'Véhicule', tour.vehicle),
                      _buildInfoRow(context, 'Chauffeur', tour.driver),
                      _buildInfoRow(
                        context, 
                        'Convoyeurs', 
                        tour.convoyeurs.join(', ')
                      ),
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
                                      text: '${tour.completedPassages}',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' / ${tour.totalPassages}',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                              // Navigation vers les détails de la tournée
                              // À implémenter
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
                        value: tour.completedPassages / tour.totalPassages,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        color: Theme.of(context).colorScheme.primary,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(Sizes.borderRadiusSmall),
                      ),
                      const SizedBox(height: Sizes.sm),
                      Text(
                        '${(tour.completedPassages / tour.totalPassages * 100).toStringAsFixed(0)}% complété',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: Sizes.xl),
              
              // Bouton de validation du retour
              if (tour.status != TourStatus.terminee)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _validateTourReturn,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Valider le retour de tournée'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: Sizes.md),
                    ),
                  ),
                ),
              
              const SizedBox(height: Sizes.md),
              
              // Bouton pour accéder à l'application principale
              if (tour.status == TourStatus.terminee)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    icon: const Icon(Icons.app_registration),
                    label: const Text('Accéder à l\'application'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: Sizes.md),
                    ),
                  ),
                ),
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