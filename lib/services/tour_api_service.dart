import '../providers/api_provider.dart';
import '../model/tp_tourne.dart';

/// API Service for Tour-related endpoints
class TourApiService {
  final ApiProvider apiProvider;
  
  TourApiService(this.apiProvider);
  
  /// Get all tours
  Future<List<TpTourne>> getTours() async {
    final response = await apiProvider.get('/tours');
    
    if (response is List) {
      return response.map((item) => TpTourne.fromJson(item)).toList();
    }
    
    return [];
  }
  
  /// Get tour details by ID
  Future<Map<String, dynamic>> getTourDetails(String tourId) async {
    final response = await apiProvider.get('/tours/$tourId/details');
    return response;
  }
  
  /// Update tour status
  Future<bool> updateTourStatus(String tourId, int statusId) async {
    try {
      await apiProvider.put('/tours/$tourId/status', body: {
        'statusId': statusId,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}