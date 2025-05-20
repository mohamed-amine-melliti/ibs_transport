import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Base API Provider class that handles common API functionality
class ApiProvider with ChangeNotifier {
  final String baseUrl;
  final http.Client client;
  final Map<String, String> defaultHeaders;
  
  ApiProvider({
    required this.baseUrl,
    http.Client? client,
    Map<String, String>? headers,
  }) : 
    this.client = client ?? http.Client(),
    this.defaultHeaders = headers ?? {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  
  /// Generic GET request
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {...defaultHeaders, ...?headers},
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Generic POST request
  Future<dynamic> post(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {...defaultHeaders, ...?headers},
        body: body != null ? json.encode(body) : null,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Generic PUT request
  Future<dynamic> put(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {...defaultHeaders, ...?headers},
        body: body != null ? json.encode(body) : null,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Generic DELETE request
  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {...defaultHeaders, ...?headers},
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Handle API response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
  
  /// Handle errors
  Exception _handleError(dynamic error) {
    // You can customize error handling here
    return Exception('API Request Failed: $error');
  }
  
  @override
  void dispose() {
    client.close();
    super.dispose();
  }
}