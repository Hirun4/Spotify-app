import 'package:cloud_firestore/cloud_firestore.dart';

class VideoEntity {
  final String title;
  final String artist;
  final num duration;
  final Timestamp releaseDate;
  final String videoId;

  VideoEntity({
    required this.title,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.videoId,
  });
}
