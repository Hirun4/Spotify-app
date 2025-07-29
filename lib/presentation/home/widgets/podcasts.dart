import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_app/data/models/podcast/podcast.dart';
import 'package:spotify_app/domain/entities/podcast/podcast.dart';

class PodcastsWidget extends StatelessWidget {
  const PodcastsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Podcasts')
          .orderBy('releaseDate', descending: true)
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
                Text('Error loading podcasts'),
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
                Icon(Icons.podcasts_outlined, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text('No podcasts available'),
                SizedBox(height: 4),
                Text('Tap the test button to add sample data',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          );
        }

        List<PodcastEntity> podcasts = snapshot.data!.docs.map((doc) {
          PodcastModel podcastModel =
              PodcastModel.fromJson(doc.data() as Map<String, dynamic>);
          podcastModel.podcastId = doc.id;
          return podcastModel.toEntity();
        }).toList();

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: podcasts.length,
          separatorBuilder: (context, index) => SizedBox(width: 14),
          itemBuilder: (context, index) {
            final podcast = podcasts[index];
            return GestureDetector(
              onTap: () {
                // TODO: Navigate to podcast player
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Playing: ${podcast.title}')),
                );
              },
              child: Container(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[300],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.mic,
                                  size: 48,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _formatDuration(podcast.duration.toInt()),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      podcast.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'by ${podcast.host}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      podcast.description,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  String _formatDuration(int seconds) {
    if (seconds >= 3600) {
      int hours = seconds ~/ 3600;
      int minutes = (seconds % 3600) ~/ 60;
      return '${hours}h ${minutes}m';
    } else {
      int minutes = seconds ~/ 60;
      return '${minutes}m';
    }
  }
}
