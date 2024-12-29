import 'package:spotify_app/domain/entities/song/song.dart';

abstract class FavoriteSongsState {}

class FavoriteSongsLoading extends FavoriteSongsState {}

class FavoriteSongsLoaded extends FavoriteSongsState {
    final List<SongEntity> favoriteSongs;
  FavoriteSongsLoaded({required this.favoriteSongs});
}

class FavoriteSongsFailure extends FavoriteSongsState {}