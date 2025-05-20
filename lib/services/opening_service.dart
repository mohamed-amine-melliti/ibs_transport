import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model/tp_passage.dart';
import '../model/tp_tourne.dart';
import '../model/tp_tourne_repository.dart';

class OpeningService {
  // Method to fetch opening data from API
  Future<Map<String, dynamic>> fetchOpeningData() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://172.20.20.119:8082/ibs-api/ibs-api/tourne/ouvertureJournee'),
        headers: {'accept': '*/*', 'Content-Type': 'application/json'},
        body: jsonEncode({
          "centreFortId": "1",
          "dateJourne": "2025-01-22",
          "equipementId": "PDA200",
          "login": "admin",
          "password": ""
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final successOrNot = data['success'];
        final passage = TpPassage.fromJson(data['data']);
        
        if (successOrNot) {
          // Save passage data to database
          await _savePassageData(passage);
          
          return {
            'success': true,
            'passage': passage,
            'data': data
          };
        } else {
          return {
            'success': false,
            'errorMessage': 'API returned failure status'
          };
        }
      } else {
        return {
          'success': false,
          'errorMessage': 'Failed to load data: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'errorMessage': 'Error fetching data: $e'
      };
    }
  }

  // Helper method to save passage data
  Future<void> _savePassageData(TpPassage passage) async {
    // Implementation of saving passage data
    // This would be similar to what was in the original method
  }
  
  // Method to save tourne data
  Future<void> saveTourneData(TpTourne tourne) async {
    final tourneRepository = TpTourneRepository();
    final existingTourne = await tourneRepository.getById(tourne.tourneId.toString());
    if (existingTourne != null) {
      await tourneRepository.update(tourne);
    } else {
      await tourneRepository.insert(tourne);
    }
  }
}