import 'package:cloud_firestore/cloud_firestore.dart';

class PodcastEntity {
  final String title;
  final String host;
  final num duration;
  final Timestamp releaseDate;
  final String description;
  final String podcastId;

  PodcastEntity({
    required this.title,
    required this.host,
    required this.duration,
    required this.releaseDate,
    required this.description,
    required this.podcastId,
  });
}
