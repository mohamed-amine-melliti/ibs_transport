import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../constants/style.dart';
import '../ui/device.dart' as device;
import '../ui/widgets/default_card.dart';

// Définition des statuts possibles pour une collecte
enum CollecteStatus { enCours, realisee }

// Extension pour obtenir le libellé du statut
extension CollecteStatusExtension on CollecteStatus {
  String get label {
    switch (this) {
      case CollecteStatus.enCours:
        return 'En cours';
      case CollecteStatus.realisee:
        return 'Réalisée';
    }
  }

  Color getColor(BuildContext context) {
    switch (this) {
      case CollecteStatus.enCours:
        return Colors.blue;
      case CollecteStatus.realisee:
        return Colors.green;
    }
  }
}

// Modèle de données pour un objet collecté
class ObjetCollecte {
  final String reference;
  final String type; // billet, monnaie, etc.
  final double montant;
  final int quantite;
  final String codeBarres;
  final DateTime dateCollecte;
  final bool ticketImprime;

  ObjetCollecte({
    required this.reference,
    required this.type,
    required this.montant,
    required this.quantite,
    required this.codeBarres,
    required this.dateCollecte,
    this.ticketImprime = false,
  });
}

// Modèle de données pour une collecte
class Collecte {
  final String id;
  final String clientName;
  final CollecteStatus status;
  final List<ObjetCollecte> objetsCollectes;
  final DateTime dateDebut;
  final DateTime? dateFin;

  Collecte({
    required this.id,
    required this.clientName,
    required this.status,
    this.objetsCollectes = const [],
    required this.dateDebut,
    this.dateFin,
  });

  // Calculer le montant total de la collecte
  double get montantTotal => objetsCollectes.fold(
      0, (previousValue, objet) => previousValue + (objet.montant * objet.quantite));

  // Vérifier si tous les tickets ont été imprimés
  bool get tousTicketsImprimes =>
      objetsCollectes.isNotEmpty &&
      objetsCollectes.every((objet) => objet.ticketImprime);
}

// Provider pour la collecte en cours
final collecteEnCoursProvider = StateProvider<Collecte?>((ref) => null);

// Provider pour la liste des objets collectés
final objetsCollectesProvider = StateProvider<List<ObjetCollecte>>((ref) => []);

// Provider pour le code-barres scanné
final codeBarresScanneProvider = StateProvider<String?>((ref) => null);

class CollectePage extends ConsumerStatefulWidget {
  const CollectePage({super.key});

  @override
  ConsumerState<CollectePage> createState() => _CollectePageState();
}

class _CollectePageState extends ConsumerState<CollectePage> {
  final TextEditingController _scanController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  
  // Simuler un scanner de code-barres
  Timer? _scannerTimer;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    // Initialiser une collecte si aucune n'est en cours
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(collecteEnCoursProvider) == null) {
        _demarrerNouvelleCollecte();
      }
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    _referenceController.dispose();
    _typeController.dispose();
    _montantController.dispose();
    _quantiteController.dispose();
    _scannerTimer?.cancel();
    super.dispose();
  }

  void _demarrerNouvelleCollecte() {
    // Créer une nouvelle collecte
    final nouvelleCollecte = Collecte(
      id: 'COL-${DateTime.now().millisecondsSinceEpoch}',
      clientName: 'Banque Centrale de Manouba', // À remplacer par un sélecteur de client
      status: CollecteStatus.enCours,
      dateDebut: DateTime.now(),
      objetsCollectes: [],
    );
    
    ref.read(collecteEnCoursProvider.notifier).state = nouvelleCollecte;
    ref.read(objetsCollectesProvider.notifier).state = [];
  }

  void _terminerCollecte() {
    final collecte = ref.read(collecteEnCoursProvider);
    if (collecte != null) {
      // Mettre à jour la collecte avec le statut terminé
      final collecteTerminee = Collecte(
        id: collecte.id,
        clientName: collecte.clientName,
        status: CollecteStatus.realisee,
        objetsCollectes: collecte.objetsCollectes,
        dateDebut: collecte.dateDebut,
        dateFin: DateTime.now(),
      );
      
      ref.read(collecteEnCoursProvider.notifier).state = collecteTerminee;
      
      // Afficher une confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Collecte terminée avec succès')),
      );
      
      // Redémarrer une nouvelle collecte après un délai
      Future.delayed(const Duration(seconds: 2), () {
        _demarrerNouvelleCollecte();
      });
    }
  }

  void _simulerScan() {
    setState(() {
      _isScanning = true;
    });
    
    // Simuler un scan après un délai aléatoire
    _scannerTimer = Timer(const Duration(seconds: 1), () {
      // Générer un code-barres aléatoire
      final codeBarres = 'IBIS-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      _scanController.text = codeBarres;
      ref.read(codeBarresScanneProvider.notifier).state = codeBarres;
      
      // Pré-remplir les champs avec des données simulées
      _referenceController.text = 'REF-${codeBarres.substring(5, 10)}';
      _typeController.text = ['Billets', 'Monnaie', 'Chèques', 'Valeurs'][DateTime.now().second % 4];
      _montantController.text = (1000 + (DateTime.now().millisecond * 10)).toString();
      _quantiteController.text = (1 + (DateTime.now().second % 10)).toString();
      
      setState(() {
        _isScanning = false;
      });
    });
  }

  void _ajouterObjet() {
    if (_referenceController.text.isEmpty ||
        _typeController.text.isEmpty ||
        _montantController.text.isEmpty ||
        _quantiteController.text.isEmpty ||
        _scanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    // Créer un nouvel objet collecté
    final nouvelObjet = ObjetCollecte(
      reference: _referenceController.text,
      type: _typeController.text,
      montant: double.tryParse(_montantController.text) ?? 0,
      quantite: int.tryParse(_quantiteController.text) ?? 0,
      codeBarres: _scanController.text,
      dateCollecte: DateTime.now(),
    );

    // Ajouter l'objet à la liste
    final objets = [...ref.read(objetsCollectesProvider)];
    objets.add(nouvelObjet);
    ref.read(objetsCollectesProvider.notifier).state = objets;

    // Mettre à jour la collecte en cours
    final collecte = ref.read(collecteEnCoursProvider);
    if (collecte != null) {
      ref.read(collecteEnCoursProvider.notifier).state = Collecte(
        id: collecte.id,
        clientName: collecte.clientName,
        status: collecte.status,
        objetsCollectes: objets,
        dateDebut: collecte.dateDebut,
        dateFin: collecte.dateFin,
      );
    }

    // Réinitialiser les champs
    _scanController.clear();
    _referenceController.clear();
    _typeController.clear();
    _montantController.clear();
    _quantiteController.clear();
    ref.read(codeBarresScanneProvider.notifier).state = null;

    // Afficher une confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Objet ajouté à la collecte')),
    );
  }

  void _imprimerTicket(ObjetCollecte objet) {
    // Simuler l'impression d'un ticket
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Impression du ticket pour ${objet.reference}')),
    );

    // Mettre à jour l'objet avec le statut d'impression
    final objets = [...ref.read(objetsCollectesProvider)];
    final index = objets.indexWhere((o) => o.codeBarres == objet.codeBarres);
    if (index != -1) {
      objets[index] = ObjetCollecte(
        reference: objet.reference,
        type: objet.type,
        montant: objet.montant,
        quantite: objet.quantite,
        codeBarres: objet.codeBarres,
        dateCollecte: objet.dateCollecte,
        ticketImprime: true,
      );
      ref.read(objetsCollectesProvider.notifier).state = objets;

      // Mettre à jour la collecte en cours
      final collecte = ref.read(collecteEnCoursProvider);
      if (collecte != null) {
        ref.read(collecteEnCoursProvider.notifier).state = Collecte(
          id: collecte.id,
          clientName: collecte.clientName,
          status: collecte.status,
          objetsCollectes: objets,
          dateDebut: collecte.dateDebut,
          dateFin: collecte.dateFin,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final collecte = ref.watch(collecteEnCoursProvider);
    final objets = ref.watch(objetsCollectesProvider);
    final codeBarresScanne = ref.watch(codeBarresScanneProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saisie des collectes'),
        actions: [
          if (collecte != null && collecte.status == CollecteStatus.enCours)
            IconButton(
              icon: const Icon(Icons.check_circle),
              onPressed: objets.isEmpty ? null : _terminerCollecte,
              tooltip: 'Terminer la collecte',
            ),
        ],
      ),
      body: collecte == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // En-tête de la collecte
                Container(
                  padding: const EdgeInsets.all(MySizes.md),
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Collecte ${collecte.id}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: MySizes.sm, vertical: MySizes.xs),
                            decoration: BoxDecoration(
                              color: collecte.status
                                  .getColor(context)
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                  MySizes.borderRadiusSmall),
                            ),
                            child: Text(
                              collecte.status.label,
                              style: TextStyle(
                                color: collecte.status.getColor(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: MySizes.xs),
                      Text(
                        'Client: ${collecte.clientName}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: MySizes.xs),
                      Text(
                        'Début: ${collecte.dateDebut.toString().substring(0, 16)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (collecte.dateFin != null)
                        Text(
                          'Fin: ${collecte.dateFin.toString().substring(0, 16)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      const SizedBox(height: MySizes.xs),
                      Text(
                        'Montant total: ${collecte.montantTotal.toStringAsFixed(2)} €',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Scanner et formulaire de saisie
                if (collecte.status == CollecteStatus.enCours)
                  Padding(
                    padding: const EdgeInsets.all(MySizes.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scanner un objet',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: MySizes.sm),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _scanController,
                                decoration: const InputDecoration(
                                  labelText: 'Code-barres',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.qr_code_scanner),
                                ),
                                readOnly: true,
                              ),
                            ),
                            const SizedBox(width: MySizes.sm),
                            ElevatedButton.icon(
                              onPressed: _isScanning ? null : _simulerScan,
                              icon: _isScanning
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.camera_alt),
                              label: Text(_isScanning ? 'Scan...' : 'Scanner'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: MySizes.md),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: MySizes.md),
                        if (codeBarresScanne != null) ...[  
                          Text(
                            'Informations de l\'objet',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: MySizes.sm),
                          TextField(
                            controller: _referenceController,
                            decoration: const InputDecoration(
                              labelText: 'Référence',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: MySizes.sm),
                          TextField(
                            controller: _typeController,
                            decoration: const InputDecoration(
                              labelText: 'Type (billet, monnaie, etc.)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: MySizes.sm),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _montantController,
                                  decoration: const InputDecoration(
                                    labelText: 'Montant unitaire (€)',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: MySizes.sm),
                              Expanded(
                                child: TextField(
                                  controller: _quantiteController,
                                  decoration: const InputDecoration(
                                    labelText: 'Quantité',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: MySizes.md),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _ajouterObjet,
                              icon: const Icon(Icons.add_circle),
                              label: const Text('Ajouter à la collecte'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                    vertical: MySizes.md),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                
                // Liste des objets collectés
                Expanded(
                  child: objets.isEmpty
                      ? Center(
                          child: Text(
                            collecte.status == CollecteStatus.enCours
                                ? 'Scannez des objets pour commencer la collecte'
                                : 'Aucun objet dans cette collecte',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(MySizes.md),
                          itemCount: objets.length,
                          itemBuilder: (context, index) {
                            final objet = objets[index];
                            return _buildObjetCard(context, objet);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildObjetCard(BuildContext context, ObjetCollecte objet) {
    final collecte = ref.watch(collecteEnCoursProvider);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: MySizes.md),
      child: DefaultCard(
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
                      objet.reference,
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
                      color: objet.ticketImprime
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(MySizes.borderRadiusSmall),
                    ),
                    child: Text(
                      objet.ticketImprime ? 'Ticket imprimé' : 'À imprimer',
                      style: TextStyle(
                        color: objet.ticketImprime ? Colors.green : Colors.orange,
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
                  _buildInfoChip(context, objet.type, Icons.category),
                  const SizedBox(width: MySizes.sm),
                  _buildInfoChip(
                      context, objet.codeBarres, Icons.qr_code_scanner),
                ],
              ),
              const SizedBox(height: MySizes.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Montant: ${(objet.montant * objet.quantite).toStringAsFixed(2)} € (${objet.quantite} x ${objet.montant.toStringAsFixed(2)} €)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              if (collecte?.status == CollecteStatus.enCours && !objet.ticketImprime)
                Padding(
                  padding: const EdgeInsets.only(top: MySizes.md),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _imprimerTicket(objet),
                      icon: const Icon(Icons.print),
                      label: const Text('Imprimer le ticket'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
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

  Widget _buildInfoChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: MySizes.sm, vertical: MySizes.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
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
}