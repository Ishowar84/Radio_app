// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/station_provider.dart';
import '../widgets/player_bar.dart';
import '../widgets/station_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCountryCode = 'NP'; // Default to Nepal
  String _selectedTag = 'all'; // Default to all

  // Example lists. In a real app, you'd fetch these from the API.
  final Map<String, String> _countries = {
    'NP': 'Nepal',
    'IN': 'India',
    'US': 'USA',
    'GB': 'UK',
    'AU': 'Australia',
  };

  final List<String> _tags = ['all', 'pop', 'news', 'talk', 'classic rock'];

  @override
  void initState() {
    super.initState();
    // Fetch initial stations for Nepal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StationProvider>(context, listen: false).fetchStations(countryCode: _selectedCountryCode);
    });
  }

  void _onFilterChanged() {
    final provider = Provider.of<StationProvider>(context, listen: false);
    if (_selectedTag != 'all') {
      provider.fetchStations(tag: _selectedTag);
    } else {
      provider.fetchStations(countryCode: _selectedCountryCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('World Radio'),
      ),
      body: Column(
        children: [
          _buildFilters(),
          _buildStationList(),
        ],
      ),
      bottomNavigationBar: const PlayerBar(),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Country Dropdown
          DropdownButton<String>(
            value: _selectedCountryCode,
            items: _countries.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCountryCode = value;
                  _selectedTag = 'all'; // Reset tag when country changes
                });
                _onFilterChanged();
              }
            },
          ),
          // Tag Dropdown
          DropdownButton<String>(
            value: _selectedTag,
            items: _tags.map((tag) {
              return DropdownMenuItem<String>(
                value: tag,
                child: Text(tag.capitalize()),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedTag = value;
                });
                _onFilterChanged();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStationList() {
    return Consumer<StationProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
        if (provider.errorMessage.isNotEmpty) {
          return Expanded(child: Center(child: Text('Error: ${provider.errorMessage}')));
        }
        if (provider.stations.isEmpty) {
          return const Expanded(child: Center(child: Text('No stations found.')));
        }

        return Expanded(
          child: ListView.builder(
            itemCount: provider.stations.length,
            itemBuilder: (context, index) {
              final station = provider.stations[index];
              return StationListTile(station: station);
            },
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}