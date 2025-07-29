import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_app/data/models/artist/artist.dart';
import 'package:spotify_app/domain/entities/artist/artist.dart';

class ArtistsWidget extends StatelessWidget {
  const ArtistsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Artists')
          .orderBy('followers', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 8),
                Text('Error loading artists'),
                Text(snapshot.error.toString(), style: TextStyle(fontSize: 12)),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text('No artists available'),
                SizedBox(height: 4),
                Text('Tap the test button to add sample data',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          );
        }

        List<ArtistEntity> artists = snapshot.data!.docs.map((doc) {
          ArtistModel artistModel =
              ArtistModel.fromJson(doc.data() as Map<String, dynamic>);
          artistModel.artistId = doc.id;
          return artistModel.toEntity();
        }).toList();

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: artists.length,
          separatorBuilder: (context, index) => SizedBox(width: 14),
          itemBuilder: (context, index) {
            final artist = artists[index];
            return GestureDetector(
              onTap: () {
                // TODO: Navigate to artist profile
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Viewing: ${artist.name}')),
                );
              },
              child: Container(
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      artist.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      artist.genre,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${_formatFollowers(artist.followers)} followers',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatFollowers(int followers) {
    if (followers >= 1000000) {
      return '${(followers / 1000000).toStringAsFixed(1)}M';
    } else if (followers >= 1000) {
      return '${(followers / 1000).toStringAsFixed(1)}K';
    }
    return followers.toString();
  }
}
