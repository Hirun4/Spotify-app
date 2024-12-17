import 'package:dartz/dartz.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();
}

class SongFirebaseImpl extends SongFirebaseService {
  @override
  Future<Either> getNewsSongs() {
    // TODO: implement getNewsSongs
    throw UnimplementedError();
  }
}
