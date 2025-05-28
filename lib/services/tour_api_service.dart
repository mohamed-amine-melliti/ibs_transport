import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/tp_tourne.dart';

/// API Service for Tour-related endpoints
class TourApiService {
  final String baseUrl = 'http://172.20.20.83:8082/ibs-api';
  
  /// Fetch tour opening data from API
  Future<Map<String, dynamic>> fetchTourOpeningData({
    required String centreFortId,
    required String dateJourne,
    required String equipementId,
    required String login,
    String password = "",
  }) async {
    try {
      String username = 'admin';
      String password = 'smartup2025';
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

      final response = await http.post(
        Uri.parse('$baseUrl/tourne/ouvertureTourne'),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "centreFortId": centreFortId,
          "dateJourne": dateJourne,
          "equipementId": equipementId,
          "login": login,
          "password": password
        }),
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['success']) {
          return {
            'success': true,
            'tour': TpTourne.fromJson(jsonData['data']),
            'rawData': jsonData['data']
          };
        } else {
          return {
            'success': false,
            'errorMessage': jsonData['message'] ?? 'Unknown error'
          };
        }
      } else {
        return {
          'success': false,
          'errorMessage': 'HTTP Error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'errorMessage': 'Exception: $e'
      };
    }
  }
  
  /// Sync tour data with server
  Future<Map<String, dynamic>> syncTour(TpTourne tour) async {
    // Implement the sync functionality here
    // This is a placeholder for the actual implementation
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    
    return {
      'success': true,
      'message': 'Tour synchronized successfully'
    };
  }
}