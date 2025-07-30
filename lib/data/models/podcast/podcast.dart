import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_app/domain/entities/podcast/podcast.dart';

class PodcastModel {
  String? title;
  String? host;
  num? duration;
  Timestamp? releaseDate;
  String? description;
  String? podcastId;

  PodcastModel({
    required this.title,
    required this.host,
    required this.duration,
    required this.releaseDate,
    required this.description,
    required this.podcastId,
  });

  PodcastModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    host = data['host'];
    description = data['description'] ?? '';

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

extension PodcastModelX on PodcastModel {
  PodcastEntity toEntity() {
    return PodcastEntity(
      title: title!,
      host: host!,
      duration: duration!,
      releaseDate: releaseDate!,
      description: description!,
      podcastId: podcastId!,
    );
  }
}
