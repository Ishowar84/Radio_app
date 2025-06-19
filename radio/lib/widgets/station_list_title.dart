// lib/widgets/station_list_tile.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/radio_station.dart';
import '../services/audio_player_service.dart';

class StationListTile extends StatelessWidget {
  final RadioStation station;

  const StationListTile({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final audioPlayerService = Provider.of<AudioPlayerService>(context, listen: false);

    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: station.favicon,
        placeholder: (context, url) => const Icon(Icons.radio),
        errorWidget: (context, url, error) => const Icon(Icons.radio),
        width: 50,
        height: 50,
      ),
      title: Text(station.name),
      subtitle: Text(station.country),
      onTap: () {
        audioPlayerService.play(station);
      },
    );
  }
}