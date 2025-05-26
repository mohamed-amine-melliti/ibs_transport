import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import '../services/tour_api_service.dart';
import 'api_provider.dart';

/// Service Provider for dependency injection
class ServiceProvider extends ChangeNotifier {
  late final ApiProvider _apiProvider;
  late final TourApiService tourApiService;
  
  // Add more services as needed
  
  ServiceProvider({String? baseUrl}) {
    // Initialize the API provider
    _apiProvider = ApiProvider(
      baseUrl: baseUrl ?? 'https://api.yourdomain.com/api',
    );
    
    // Initialize services
    tourApiService = TourApiService(_apiProvider);
  }
  
  /// Factory method to create all required providers
  static List<ChangeNotifierProvider> providers() {
    return [
      ChangeNotifierProvider<ServiceProvider>(
        create: (_) => ServiceProvider(),
      ),
    ];
  }
  
  @override
  void dispose() {
    _apiProvider.dispose();
    super.dispose();
  }
}