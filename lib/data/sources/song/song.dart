import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_app/domain/entities/song/song.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();
}

class SongFirebaseImpl extends SongFirebaseService {
  @override
  Future<Either> getNewsSongs() async {
    List<SongEntity> songs = [];
    var data = await FirebaseFirestore.instance
        .collection('Songs')
        .orderBy('releaseDate', descending: true)
        .limit(3)
        .get();

    for (var element in data.docs) {
      element.data();
    }
  }
}
