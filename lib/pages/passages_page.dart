import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/style.dart';
import '../ui/device.dart' as device; // Ajout du préfixe 'device'
import '../ui/widgets/default_card.dart';

// Définition des statuts possibles pour un passage
enum PassageStatus { enAttente, enCours, termine, annule }

// Extension pour obtenir le libellé du statut
extension PassageStatusExtension on PassageStatus {
  String get label {
    switch (this) {
      case PassageStatus.enAttente:
        return 'En attente';
      case PassageStatus.enCours:
        return 'En cours';
      case PassageStatus.termine:
        return 'Terminé';
      case PassageStatus.annule:
        return 'Annulé';
    }
  }

  Color getColor(BuildContext context) {
    switch (this) {
      case PassageStatus.enAttente:
        return Colors.orange;
      case PassageStatus.enCours:
        return Colors.blue;
      case PassageStatus.termine:
        return Colors.green;
      case PassageStatus.annule:
        return Colors.red;
    }
  }
}

// Modèle de données pour un passage
class Passage {
  final String id;
  final String clientName;
  final String type;
  final String code;
  final PassageStatus status;
  final List<String> objetsCollectes;
  final String resultat;
  final double montant; // Ajout du montant pour le transport d'argent

  Passage({
    required this.id,
    required this.clientName,
    required this.type,
    required this.code,
    required this.status,
    this.objetsCollectes = const [],
    this.resultat = '',
    this.montant = 0.0, // Valeur par défaut pour le montant
  });
}

// Provider pour la liste des passages (à remplacer par une vraie implémentation)
final passagesProvider = StateProvider<List<Passage>>((ref) {
  // Exemple de données pour démonstration
  return [
    Passage(
      id: 'IBIS-001',
      clientName: 'Banque Centrale de Manouba',
      type: 'Transport de fonds',
      code: 'BCF-123',
      status: PassageStatus.termine,
      objetsCollectes: ['Coffre sécurisé #A123', 'Valise blindée #B456'],
      resultat: 'Transport effectué avec succès',
      montant: 250000.0,
    ),
    Passage(
      id: 'IBIS-002',
      clientName: 'Distributeurs Automatiques Tunis',
      type: 'Rechargement DAB',
      code: 'DAB-456',
      status: PassageStatus.enCours,
      objetsCollectes: [],
      resultat: '',
      montant: 75000.0,
    ),
    Passage(
      id: 'IBIS-003',
      clientName: 'Bijouterie Diamant Sécurité',
      type: 'Transport de valeurs',
      code: 'TVS-789',
      status: PassageStatus.enAttente,
      objetsCollectes: [],
      resultat: '',
      montant: 500000.0,
    ),
    Passage(
      id: 'IBIS-004',
      clientName: 'Centre Commercial Sécurité',
      type: 'Collecte de recettes',
      code: 'CCR-012',
      status: PassageStatus.enAttente,
      objetsCollectes: [],
      resultat: '',
      montant: 125000.0,
    ),
    Passage(
      id: 'IBIS-005',
      clientName: 'Agence Bancaire Ariana',
      type: 'Transport de fonds',
      code: 'ABM-345',
      status: PassageStatus.annule,
      objetsCollectes: [],
      resultat: 'Problème de sécurité sur site',
      montant: 180000.0,
    ),
  ];
});

// Provider pour le passage sélectionné
final selectedPassageProvider = StateProvider<Passage?>((ref) => null);

class PassagesPage extends ConsumerStatefulWidget {
  const PassagesPage({super.key});

  @override
  ConsumerState<PassagesPage> createState() => _PassagesPageState();
}

class _PassagesPageState extends ConsumerState<PassagesPage> {
  // Clé pour le Scaffold pour pouvoir ouvrir le drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    final passages = ref.watch(passagesProvider);
    final selectedPassage = ref.watch(selectedPassageProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Passages Ibis Transport'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implémentation du filtre à venir
            },
            tooltip: 'Filtrer les passages',
          ),
        ],
      ),
      // Ajout du drawer qui s'ouvre de la gauche vers la droite
      endDrawer: selectedPassage != null ? _buildPassageDetailsDrawer(context, selectedPassage) : null,
      body: passages.isEmpty
          ? const Center(child: Text('Aucun passage à afficher'))
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(MySizes.md),
              itemCount: passages.length,
              itemBuilder: (context, index) {
                final passage = passages[index];
                return _buildPassageCard(context, passage);
              },
            ),
    );
  }

  Widget _buildPassageCard(BuildContext context, Passage passage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MySizes.md),
      child: DefaultCard(
        onTap: () {
          // Sélectionner le passage et ouvrir le drawer au lieu du bottom sheet
          ref.read(selectedPassageProvider.notifier).state = passage;
          _scaffoldKey.currentState?.openEndDrawer();
        },
        child: Padding(
          padding: const EdgeInsets.all(MySizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      passage.clientName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MySizes.sm, vertical: MySizes.xs),
                    decoration: BoxDecoration(
                      color: passage.status.getColor(context).withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(MySizes.borderRadiusSmall),
                    ),
                    child: Text(
                      passage.status.label,
                      style: TextStyle(
                        color: passage.status.getColor(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MySizes.sm),
              Row(
                children: [
                  _buildInfoChip(context, passage.type, Icons.security),
                  const SizedBox(width: MySizes.sm),
                  _buildInfoChip(context, passage.code, Icons.qr_code),
                ],
              ),
              const SizedBox(height: MySizes.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Montant: ${passage.montant.toStringAsFixed(2)} €',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (passage.status == PassageStatus.termine)
                    Text(
                      'Objets: ${passage.objetsCollectes.length}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: MySizes.sm, vertical: MySizes.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(MySizes.borderRadiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // Nouveau widget pour le drawer des détails de passage
  Widget _buildPassageDetailsDrawer(BuildContext context, Passage passage) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85, // Largeur du drawer
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Détails du passage Ibis',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: MySizes.sm, vertical: MySizes.xs),
                decoration: BoxDecoration(
                  color: passage.status.getColor(context).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(MySizes.borderRadiusSmall),
                ),
                child: Text(
                  passage.status.label,
                  style: TextStyle(
                    color: passage.status.getColor(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: MySizes.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(context, 'ID', passage.id),
                      _buildDetailRow(context, 'Client', passage.clientName),
                      _buildDetailRow(context, 'Type', passage.type),
                      _buildDetailRow(context, 'Code', passage.code),
                      _buildDetailRow(context, 'Montant', '${passage.montant.toStringAsFixed(2)} €'),
                      const Divider(height: MySizes.xl),
                      Text(
                        'Objets sécurisés',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: MySizes.sm),
                      passage.objetsCollectes.isEmpty
                          ? const Text('Aucun objet sécurisé transporté')
                          : Column(
                              children: passage.objetsCollectes
                                  .map((objet) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: MySizes.xs),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.security,
                                                size: 16, color: Colors.green),
                                            const SizedBox(width: MySizes.xs),
                                            Text(objet),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                      const SizedBox(height: MySizes.lg),
                      Text(
                        'Résultat',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: MySizes.sm),
                      Text(passage.resultat.isEmpty
                          ? 'Pas encore de résultat'
                          : passage.resultat),
                    ],
                  ),
                ),
              ),
              // Add more space before the buttons
              const SizedBox(height: MySizes.xl),
              // Buttons section with smaller styling
              if (passage.status == PassageStatus.termine)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: MySizes.md),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Logique pour remettre en attente
                      Navigator.pop(context);
                      // Mettre à jour le statut du passage
                      final passages = [...ref.read(passagesProvider)];
                      final index =
                          passages.indexWhere((p) => p.id == passage.id);
                      if (index != -1) {
                        passages[index] = Passage(
                          id: passage.id,
                          clientName: passage.clientName,
                          type: passage.type,
                          code: passage.code,
                          status: PassageStatus.enAttente,
                          objetsCollectes: passage.objetsCollectes,
                          resultat: '',
                          montant: passage.montant,
                        );
                        ref.read(passagesProvider.notifier).state = passages;
                      }
                    },
                    icon: const Icon(Icons.restore, size: 20),
                    label: const Text('Remettre en attente', 
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: MySizes.md),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MySizes.borderRadiusSmall),
                      ),
                    ),
                  ),
                ),
              // New button for changing status to "En Cours"
              if (passage.status == PassageStatus.enAttente)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: MySizes.md),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Logique pour marquer comme en cours
                      Navigator.pop(context);
                      // Mettre à jour le statut du passage
                      final passages = [...ref.read(passagesProvider)];
                      final index =
                          passages.indexWhere((p) => p.id == passage.id);
                      if (index != -1) {
                        passages[index] = Passage(
                          id: passage.id,
                          clientName: passage.clientName,
                          type: passage.type,
                          code: passage.code,
                          status: PassageStatus.enCours,
                          objetsCollectes: passage.objetsCollectes,
                          resultat: '',
                          montant: passage.montant,
                        );
                        ref.read(passagesProvider.notifier).state = passages;
                      }
                    },
                    icon: const Icon(Icons.play_arrow, size: 20),
                    label: const Text('Démarrer le passage', 
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: MySizes.md),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MySizes.borderRadiusSmall),
                      ),
                    ),
                  ),
                ),
              if (passage.status == PassageStatus.enAttente ||
                  passage.status == PassageStatus.enCours)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: MySizes.md),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Logique pour marquer comme terminé
                      Navigator.pop(context);
                      // Mettre à jour le statut du passage
                      final passages = [...ref.read(passagesProvider)];
                      final index =
                          passages.indexWhere((p) => p.id == passage.id);
                      if (index != -1) {
                        passages[index] = Passage(
                          id: passage.id,
                          clientName: passage.clientName,
                          type: passage.type,
                          code: passage.code,
                          status: PassageStatus.termine,
                          objetsCollectes: passage.objetsCollectes,
                          resultat: 'Transport sécurisé complété',
                          montant: passage.montant,
                        );
                        ref.read(passagesProvider.notifier).state = passages;
                      }
                    },
                    icon: const Icon(Icons.check_circle, size: 20),
                    label: const Text('Marquer comme terminé', 
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: MySizes.md),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MySizes.borderRadiusSmall),
                      ),
                    ),
                  ),
                ),
              if (passage.status == PassageStatus.enCours)
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/collecte',
                        arguments: {
                          'passageId': passage.id,
                          'clientName': passage.clientName,
                        },
                      );
                    },
                    icon: const Icon(Icons.add_box, size: 20),
                    label: const Text('Saisir une collecte',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: MySizes.md),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MySizes.borderRadiusSmall),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MySizes.md),
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
