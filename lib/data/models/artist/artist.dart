import 'package:spotify_app/domain/entities/artist/artist.dart';

class ArtistModel {
  String? name;
  String? genre;
  int? followers;
  String? imageUrl;
  String? artistId;

  ArtistModel({
    required this.name,
    required this.genre,
    required this.followers,
    required this.imageUrl,
    required this.artistId,
  });

  ArtistModel.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    genre = data['genre'];
    followers = data['followers'] ?? 0;
    imageUrl = data['imageUrl'] ?? '';
  }
}

extension ArtistModelX on ArtistModel {
  ArtistEntity toEntity() {
    return ArtistEntity(
      name: name!,
      genre: genre!,
      followers: followers!,
      imageUrl: imageUrl!,
      artistId: artistId!,
    );
  }
}
