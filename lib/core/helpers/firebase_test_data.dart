import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTestData {
  static Future<void> addSampleSongs() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Sample songs data
      List<Map<String, dynamic>> sampleSongs = [
        {
          'title': 'Blinding Lights',
          'artist': 'The Weeknd',
          'duration': '3:20',
          'releaseDate': Timestamp.now(),
        },
        {
          'title': 'Watermelon Sugar',
          'artist': 'Harry Styles',
          'duration': '2:54',
          'releaseDate': Timestamp.now(),
        },
        {
          'title': 'Good 4 U',
          'artist': 'Olivia Rodrigo',
          'duration': '2:58',
          'releaseDate': Timestamp.now(),
        },
      ];

      print('🎵 Adding sample songs to Firestore...');

      for (var song in sampleSongs) {
        await firestore.collection('Songs').add(song);
        print('✅ Added song: ${song['title']} by ${song['artist']}');
      }

      print('🎉 All sample songs added successfully!');
    } catch (e) {
      print('❌ Error adding sample songs: $e');
    }
  }

  static Future<void> checkFirestoreConnection() async {
    try {
      print('🔍 Checking Firestore connection...');

      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Try to read from Songs collection
      final QuerySnapshot songsSnapshot =
          await firestore.collection('Songs').limit(1).get();

      print(
          '📦 Songs collection exists: ${songsSnapshot.docs.length} documents found');

      // Try to read from Users collection
      final QuerySnapshot usersSnapshot =
          await firestore.collection('Users').limit(1).get();

      print(
          '👥 Users collection exists: ${usersSnapshot.docs.length} documents found');

      print('✅ Firestore connection is working!');
    } catch (e) {
      print('❌ Firestore connection error: $e');
    }
  }
}
