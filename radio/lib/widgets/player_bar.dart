// lib/widgets/player_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_player_service.dart';
import '../models/radio_station.dart';

class PlayerBar extends StatelessWidget {
  const PlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayerService = context.watch<AudioPlayerService>();
    final RadioStation? currentStation = audioPlayerService.currentStation;

    if (currentStation == null) {
      return const SizedBox.shrink(); // Show nothing if no station is playing
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 60,
      color: Colors.blue.withOpacity(0.2),
      child: Row(
        children: [
          IconButton(
            icon: Icon(audioPlayerService.isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              if (audioPlayerService.isPlaying) {
                audioPlayerService.pause();
              } else {
                audioPlayerService.play(currentStation);
              }
            },
          ),
          Expanded(
            child: Text(
              currentStation.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: audioPlayerService.stop,
          ),
        ],
      ),
    );
  }
}