// lib/services/audio_player_service.dart
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/radio_station.dart';

class AudioPlayerService with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  RadioStation? _currentStation;
  bool _isPlaying = false;

  RadioStation? get currentStation => _currentStation;
  bool get isPlaying => _isPlaying;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  AudioPlayerService() {
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
  }

  Future<void> play(RadioStation station) async {
    if (_currentStation?.stationuuid == station.stationuuid) {
      // If it's the same station, just toggle play/pause
      if (_isPlaying) {
        await _player.pause();
      } else {
        await _player.play();
      }
    } else {
      // It's a new station
      _currentStation = station;
      try {
        await _player.setUrl(station.urlResolved);
        _player.play();
      } catch (e) {
        print("Error playing station: $e");
        _currentStation = null;
      }
    }
    notifyListeners();
  }

  Future<void> pause() async {
    await _player.pause();
    notifyListeners();
  }

  Future<void> stop() async {
    await _player.stop();
    _currentStation = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}