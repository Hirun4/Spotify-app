import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_app/domain/entities/song/song.dart';

class SongModel {
  String? title;
  String? artist;
  num? duration;
  Timestamp? releaseDate;
  bool? isFavorite;
  String? songId;

  SongModel({
    required this.title,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.isFavorite,
    required this.songId,
  });

  SongModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];

    // Handle duration conversion from string format "mm:ss" to total seconds
    if (data['duration'] is String) {
      duration = _parseDurationFromString(data['duration']);
    } else if (data['duration'] is num) {
      duration = data['duration'];
    } else {
      duration = 0; // Default fallback
    }

    releaseDate = data['releaseDate'];
  }

  // Helper method to convert "mm:ss" format to total seconds
  static num _parseDurationFromString(String durationStr) {
    try {
      final parts = durationStr.split(':');
      if (parts.length == 2) {
        final minutes = int.parse(parts[0]);
        final seconds = int.parse(parts[1]);
        return (minutes * 60) + seconds;
      }
      return 0;
    } catch (e) {
      print('⚠️ Error parsing duration "$durationStr": $e');
      return 0;
    }
  }
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      title: title!,
      artist: artist!,
      duration: duration!,
      releaseDate: releaseDate!,
      isFavorite: isFavorite!,
      songId: songId!,
    );
  }
}
