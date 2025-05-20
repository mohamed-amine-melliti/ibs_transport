import 'package:flutter/material.dart';
import '../model/tp_tourne.dart';

class TourDetailsPage extends StatelessWidget {
  final TpTourne tour;
  final Map<String, dynamic>? jsonData;
  const TourDetailsPage({Key? key, required this.tour, this.jsonData}) : super(key: key);

  Color _getStatusColor(Map<String, dynamic> passage) {
    return passage['statusId'] == 1 ? Colors.grey[300]! : Colors.green[200]!;
  }

  String _getStatusLabel(Map<String, dynamic> passage) {
    return passage['beneficierNature'] == 'DIRECT' ? "Direct" : "DOM";
  }

  @override
  Widget build(BuildContext context) {
    final passages = (jsonData != null && jsonData!['passages'] is List)
        ? List<Map<String, dynamic>>.from(jsonData!['passages'])
        : [];

    return Scaffold(
      appBar: AppBar(title: const Text('Détails des passages')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: passages.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: passages.map((passage) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.blueAccent.withOpacity(0.7),
                          width: 2.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.10),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        // Optionally, you can add a gradient background for more visual appeal:
                        // gradient: LinearGradient(
                        //   colors: [Colors.white, Colors.blue.shade50],
                        //   begin: Alignment.topLeft,
                        //   end: Alignment.bottomRight,
                        // ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // First Row: QR code icon, pointStopCode, status
                            Row(
                              children: [
                                const Icon(Icons.qr_code_2, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  passage['pointStopCode'] ?? '',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(passage),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    _getStatusLabel(passage),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Add beneficiaireNature under the code
                            if ((passage['beneficiaireNature'] ?? '').toString().isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                passage['beneficiaireNature'] ?? '',
                                style: const TextStyle(fontSize: 13, color: Colors.black54),
                              ),
                            ],

                            const SizedBox(height: 8),

                            // Second Row: pointStopLibelle & clientLibelle
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    passage['pointStopLibelle'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  passage['clientLibelle'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Third Row: Billets, Monnaie, Objets
                            Row(
                              children: [
                                Text(
                                  "Billets: ${passage['nombreRemiseBillet'] ?? 0}",
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  "Monnaie: ${passage['nombreRemiseMonnaie'] ?? 0}",
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  "Objets: ${passage['nombreRemiseObjet'] ?? 0}",
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Fourth Row: interventionLibelle & interventionNature (interventionNature aligned right)
                            Row(
                              children: [
                                Text(
                                  passage['interventionLibelle'] ?? 'Transport de fonds',
                                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      passage['interventionNature'] ?? '',
                                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )
              : const Text('No passages found.'),
        ),
      ),
    );
  }
}
