import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/style.dart';
import 'tour_page.dart';
import 'passages_page.dart';

// Provider pour suivre l'étape actuelle du stepper
final currentStepProvider = StateProvider<int>((ref) => 0);

class TourStepperPage extends ConsumerWidget {
  const TourStepperPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(currentStepProvider);
    
    return Scaffold(
      body: Column(
        children: [
          // Stepper horizontal en haut
          Container(
            padding: const EdgeInsets.symmetric(vertical: MySizes.md),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepIndicator(
                  context, 
                  0, 
                  currentStep, 
                  'Tournée',
                  Icons.route,
                  onTap: () => ref.read(currentStepProvider.notifier).state = 0,
                ),
                _buildStepConnector(context, 0, currentStep),
                _buildStepIndicator(
                  context, 
                  1, 
                  currentStep, 
                  'Passages',
                  Icons.location_on,
                  onTap: () => ref.read(currentStepProvider.notifier).state = 1,
                ),
              ],
            ),
          ),
          
          // Contenu de la page en fonction de l'étape
          Expanded(
            child: currentStep == 0 
              ? const TourPage() 
              : const PassagesPage(),
          ),
        ],
      ),
      // Boutons de navigation en bas
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: MySizes.lg, vertical: MySizes.sm), // Réduit le padding vertical
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentStep > 0)
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(currentStepProvider.notifier).state = currentStep - 1;
                  },
                  icon: const Icon(Icons.arrow_back, size: 18), // Réduit la taille de l'icône
                  label: const Text('Précédent', style: TextStyle(fontSize: 14)), // Réduit la taille du texte
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: MySizes.md, vertical: MySizes.xs), // Réduit le padding
                  ),
                ),
              if (currentStep == 0)
                const SizedBox(width: 100), // Réduit l'espace
              if (currentStep < 1)
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(currentStepProvider.notifier).state = currentStep + 1;
                  },
                  icon: const Icon(Icons.arrow_forward, size: 18), // Réduit la taille de l'icône
                  label: const Text('Suivant', style: TextStyle(fontSize: 14)), // Réduit la taille du texte
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: MySizes.md, vertical: MySizes.xs), // Réduit le padding
                  ),
                ),
              if (currentStep == 1)
                ElevatedButton.icon(
                  onPressed: () {
                    // Terminer le processus et retourner à l'application principale
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  icon: const Icon(Icons.check_circle, size: 18), // Réduit la taille de l'icône
                  label: const Text('Terminer', style: TextStyle(fontSize: 14)), // Réduit la taille du texte
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: MySizes.md, vertical: MySizes.xs), // Réduit le padding
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStepIndicator(BuildContext context, int step, int currentStep, String label, IconData icon, {required VoidCallback onTap}) {
    final isActive = step == currentStep;
    final isCompleted = step < currentStep;
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, // Réduit de 50 à 40
            height: 40, // Réduit de 50 à 40
            decoration: BoxDecoration(
              color: isActive 
                ? Theme.of(context).colorScheme.primary 
                : isCompleted 
                  ? Colors.green 
                  : Theme.of(context).colorScheme.surfaceVariant,
              shape: BoxShape.circle,
              // Ajout d'une bordure pour plus de clarté
              border: Border.all(
                color: isActive || isCompleted
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.outline.withOpacity(0.5),
                width: 1.5,
              ),
              // Ajout d'une ombre légère pour plus de profondeur
              boxShadow: isActive || isCompleted
                ? [
                    BoxShadow(
                      color: (isActive 
                        ? Theme.of(context).colorScheme.primary 
                        : Colors.green).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
            ),
            child: Center(
              child: isCompleted 
                ? const Icon(Icons.check, color: Colors.white, size: 20) // Réduit la taille de l'icône
                : Icon(
                    icon,
                    size: 20, // Réduit la taille de l'icône
                    color: isActive 
                      ? Theme.of(context).colorScheme.onPrimary 
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(height: MySizes.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 12, // Réduit la taille du texte
              color: isActive 
                ? Theme.of(context).colorScheme.primary 
                : isCompleted 
                  ? Colors.green 
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStepConnector(BuildContext context, int step, int currentStep) {
    final isCompleted = step < currentStep;
    
    return Container(
      width: 40, // Réduit de 60 à 40
      height: 2,
      color: isCompleted 
        ? Colors.green 
        : Theme.of(context).colorScheme.surfaceVariant,
    );
  }
}