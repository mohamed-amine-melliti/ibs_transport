import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://172.20.20.83:8082/ibs-api/swagger-ui.html#';
  static const String apiDocs = '$baseUrl/api-docs';
  
  String? _authToken;
  
  // Authentication
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'centreFortId': '1',

          'username': 'admin',
          'password': '',
        }),
      );   
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
        return data;
      } else {
        throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }
  
  // User Authentication
  Future<Map<String, dynamic>> authenticateUser({
    required String centreFortId,
    required String login,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/authenticate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'centreFortId': centreFortId,
          'login': login,
          'password': password,
        }),
      );
      
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }
  
  // Get Tournes
  Future<List<dynamic>> getTournes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tournes'),
        headers: _getAuthHeaders(),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get tournes: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Get tournes error: $e');
    }
  }
  
  // Get Tourne by ID
  Future<Map<String, dynamic>> getTourneById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tournes/$id'),
        headers: _getAuthHeaders(),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get tourne: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Get tourne error: $e');
    }
  }
  
  // Get Passages by Tourne ID
  Future<List<dynamic>> getPassagesByTourneId(String tourneId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/passages/tourne/$tourneId'),
        headers: _getAuthHeaders(),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get passages: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Get passages error: $e');
    }
  }
  
  // Get API Documentation
  Future<Map<String, dynamic>> getApiDocs() async {
    try {
      final response = await http.get(Uri.parse(apiDocs));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get API docs: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Get API docs error: $e');
    }
  }
  
  // Helper method to get auth headers
  Map<String, String> _getAuthHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }
  
  // Get saved configuration
  static Future<Map<String, dynamic>?> getSavedConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedConfig = prefs.getString('api_config');
      
      if (savedConfig != null) {
        return jsonDecode(savedConfig) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error loading saved config: $e');
      return null;
    }
  }
  
  Future<Map<String, dynamic>> fetchOpeningDataFromApi({
    required String centreFortId,
    required String dateJourne,
    required String equipementId,
    required String login,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('http://172.20.20.83:8082/ibs-api/swagger-ui.html#/ouvertureJournee'),
      headers: {'accept': '*/*', 'Content-Type': 'application/json'},
      body: jsonEncode({
        "centreFortId": centreFortId,
        "dateJourne": dateJourne,
        "equipementId": equipementId,
        "login": login,
        "password": password
      }),
    );
    return jsonDecode(response.body);
  }
}