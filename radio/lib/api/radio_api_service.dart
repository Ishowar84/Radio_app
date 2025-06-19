// lib/api/radio_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/radio_station.dart';

class RadioApiService {
  static const String _baseUrl = 'https://de1.api.radio-browser.info/json';

  Future<List<RadioStation>> fetchStationsByCountry(String countryCode) async {
    final response = await http.get(Uri.parse('$_baseUrl/stations/bycountrycodeexact/$countryCode'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      // Filter out stations with no valid stream URL
      return data
          .map((item) => RadioStation.fromJson(item))
          .where((station) => station.urlResolved.isNotEmpty)
          .toList();
    } else {
      throw Exception('Failed to load stations');
    }
  }

  Future<List<RadioStation>> fetchStationsByTag(String tag) async {
    final response = await http.get(Uri.parse('$_baseUrl/stations/bytag/$tag'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => RadioStation.fromJson(item))
          .where((station) => station.urlResolved.isNotEmpty)
          .toList();
    } else {
      throw Exception('Failed to load stations by tag');
    }
  }

// You would expand this with methods to get all countries and tags for the dropdowns
}