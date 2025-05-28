import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model/tp_passage.dart';
import '../model/tp_tourne.dart';
import '../model/tp_tourne_repository.dart';
import 'api_service.dart';

class OpeningService {
  final ApiService _apiService = ApiService();
  // Method to fetch opening data from API
  Future<Map<String, dynamic>> fetchOpeningData() async {
    try {
      final data = await _apiService.fetchOpeningDataFromApi(
        centreFortId: "1",
        dateJourne: "2025-01-22",
        equipementId: "PDA200",
        login: "admin",
        password: ""
      );
      final successOrNot = data['success'];
      if (successOrNot) {
        final passage = TpPassage.fromJson(data['data']);
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