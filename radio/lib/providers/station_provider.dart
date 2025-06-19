// lib/providers/station_provider.dart
import 'package:flutter/material.dart';
import '../api/radio_api_service.dart';
import '../models/radio_station.dart';

class StationProvider with ChangeNotifier {
  final RadioApiService _apiService = RadioApiService();

  List<RadioStation> _stations = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<RadioStation> get stations => _stations;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchStations({String? countryCode, String? tag}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      if (tag != null && tag.isNotEmpty) {
        _stations = await _apiService.fetchStationsByTag(tag);
      } else {
        // Default to Nepal if no country is specified
        _stations = await _apiService.fetchStationsByCountry(countryCode ?? 'NP');
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}