// lib/models/radio_station.dart
class RadioStation {
  final String stationuuid;
  final String name;
  final String urlResolved;
  final String favicon;
  final String country;
  final String countryCode;
  final String tags;

  RadioStation({
    required this.stationuuid,
    required this.name,
    required this.urlResolved,
    required this.favicon,
    required this.country,
    required this.countryCode,
    required this.tags,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    return RadioStation(
      stationuuid: json['stationuuid'] ?? '',
      name: json['name'] ?? 'Unknown Station',
      urlResolved: json['url_resolved'] ?? '',
      favicon: json['favicon'] ?? '',
      country: json['country'] ?? 'Unknown Country',
      countryCode: json['countrycode'] ?? '',
      tags: json['tags'] ?? '',
    );
  }
}