import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify_app/data/models/song/song.dart';
import 'package:spotify_app/domain/entities/song/song.dart';
import 'package:spotify_app/domain/usecases/song/is_favorite_song.dart';
import '../../../service_locator.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();
  Future<Either> getPlayList();
  Future<Either> addOrRemoveFavoriteSongs(String songId);
  Future<bool> isFavoriteSong(String songId);
  Future<Either> getUserFavoriteSongs();
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<Either> getNewsSongs() async {
    try {
      print('🎵 Starting to fetch news songs...');
      List<SongEntity> songs = [];

      print('📡 Querying Firestore collection: Songs');
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .limit(3)
          .get();

      print('📦 Retrieved ${data.docs.length} songs from Firestore');

      for (var element in data.docs) {
        print('🎵 Processing song document: ${element.id}');
        print('📄 Raw song data: ${element.data()}');

        var songModel = SongModel.fromJson(element.data());
        print('🔄 Converted to SongModel: ${songModel.title} by ${songModel.artist}');

        bool isFavorite = await sl<IsFavoriteSongUseCase>()
            .call(params: element.reference.id);
        print('❤️ Favorite status for ${songModel.title}: $isFavorite');

        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
        print('✅ Added song to list: ${songModel.title}');
      }

      print('🎉 Successfully fetched ${songs.length} news songs');
      return Right(songs);
    } catch (e) {
      print('❌ Error fetching news songs: $e');
      print('�Stack trace: ${StackTrace.current}');
      return const Left('An error occurred, please try again');
    }
  }

  @override
  Future<Either> getPlayList() async {
    try {
      print('🎵 Starting to fetch playlist...');
      List<SongEntity> songs = [];

      print('📡 Querying Firestore for playlist');
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .get();

      print('📦 Retrieved ${data.docs.length} songs for playlist');

      for (var element in data.docs) {
        print('🎵 Processing playlist song: ${element.id}');
        var songModel = SongModel.fromJson(element.data());
        print('📄 Song details: ${songModel.title} by ${songModel.artist}');

        bool isFavorite = await sl<IsFavoriteSongUseCase>()
            .call(params: element.reference.id);
        print('❤️ Favorite status: $isFavorite');

        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
        print('✅ Added to playlist: ${songModel.title}');
      }

      print('🎉 Successfully fetched playlist with ${songs.length} songs');
      return Right(songs);
    } catch (e) {
      print('❌ Error fetching playlist: $e');
      print('�Stack trace: ${StackTrace.current}');
      return const Left('An error occurred, please try again');
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteSongs(String songId) async {
    try {
      print('❤️ Starting add/remove favorite for song: $songId');
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavorite;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;
      print('👤 User ID: $uId');

      print('🔍 Checking if song is already favorite');
      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favoriteSongs.docs.isNotEmpty) {
        print('💔 Removing song from favorites');
        await favoriteSongs.docs.first.reference.delete();
        isFavorite = false;
      } else {
        print('❤️ Adding song to favorites');
        await firebaseFirestore
            .collection('Users')
            .doc(uId)
            .collection('Favorites')
            .add({'songId': songId, 'addedDate': Timestamp.now()});
        isFavorite = true;
      }
      print('✅ Successfully updated favorite status: $isFavorite');
      return Right(isFavorite);
    } catch (e) {
      print('❌ Error updating favorite status: $e');
      print('�Stack trace: ${StackTrace.current}');
      return Left('An error occurred');
    }
  }

  @override
  Future<bool> isFavoriteSong(String songId) async {
    try {
      print('🔍 Checking favorite status for song: $songId');
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = firebaseAuth.currentUser;
      String uId = user!.uid;
      print('👤 User ID: $uId');

      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();

      bool isFavorite = favoriteSongs.docs.isNotEmpty;
      print('❤️ Is favorite: $isFavorite');
      return isFavorite;
    } catch (e) {
      print('❌ Error checking favorite status: $e');
      print('�Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  @override
  Future<Either> getUserFavoriteSongs() async {
    try {
      print('🎵 Starting to fetch user favorite songs...');
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = firebaseAuth.currentUser;
      List<SongEntity> favoriteSongs = [];
      String uId = user!.uid;
      print('👤 User ID: $uId');

      print('📡 Querying user favorites');
      QuerySnapshot favoritesSnapshot = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favorites')
          .get();

      print('📦 Found ${favoritesSnapshot.docs.length} favorite songs');

      for (var element in favoritesSnapshot.docs) {
        String songId = element['songId'];
        print('🎵 Fetching details for song: $songId');

        var song = await firebaseFirestore.collection('Songs').doc(songId).get();
        print('📄 Raw song data: ${song.data()}');

        SongModel songModel = SongModel.fromJson(song.data()!);
        songModel.isFavorite = true;
        songModel.songId = songId;
        favoriteSongs.add(songModel.toEntity());
        print('✅ Added to favorites list: ${songModel.title}');
      }

      print('🎉 Successfully fetched ${favoriteSongs.length} favorite songs');
      return Right(favoriteSongs);
    } catch (e) {
      print('❌ Error fetching favorite songs: $e');
      print('�Stack trace: ${StackTrace.current}');
      return const Left('An error occurred');
    }
  }
}