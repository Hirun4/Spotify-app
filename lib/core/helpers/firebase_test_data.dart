import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTestData {
  static Future<void> addSampleSongs() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

     
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
        {
          'title': 'Levitating',
          'artist': 'Dua Lipa',
          'duration': '3:23',
          'releaseDate': Timestamp.now(),
        },
        {
          'title': 'Anti-Hero',
          'artist': 'Taylor Swift',
          'duration': '3:20',
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

  static Future<void> addSampleVideos() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      
      List<Map<String, dynamic>> sampleVideos = [
        {
          'title': 'Blinding Lights',
          'artist': 'The Weeknd',
          'duration': '4:20',
          'releaseDate': Timestamp.now(),
        },
        {
          'title': 'Shape of You',
          'artist': 'Ed Sheeran',
          'duration': '3:53',
          'releaseDate': Timestamp.now(),
        },
        {
          'title': 'Bad Guy',
          'artist': 'Billie Eilish',
          'duration': '3:14',
          'releaseDate': Timestamp.now(),
        },
        {
          'title': 'Senorita',
          'artist': 'Shawn Mendes',
          'duration': '3:07',
          'releaseDate': Timestamp.now(),
        },
      ];

      print('📹 Adding sample videos to Firestore...');

      for (var video in sampleVideos) {
        await firestore.collection('Videos').add(video);
        print('✅ Added video: ${video['title']} by ${video['artist']}');
      }

      print('🎉 All sample videos added successfully!');
    } catch (e) {
      print('❌ Error adding sample videos: $e');
    }
  }

  static Future<void> addSampleArtists() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Sample artists data
      List<Map<String, dynamic>> sampleArtists = [
        {
          'name': 'The Weeknd',
          'genre': 'R&B/Pop',
          'followers': 95000000,
          'imageUrl': '',
        },
        {
          'name': 'Taylor Swift',
          'genre': 'Pop/Country',
          'followers': 92000000,
          'imageUrl': '',
        },
        {
          'name': 'Ed Sheeran',
          'genre': 'Pop/Folk',
          'followers': 87000000,
          'imageUrl': '',
        },
        {
          'name': 'Billie Eilish',
          'genre': 'Alternative/Pop',
          'followers': 74000000,
          'imageUrl': '',
        },
        {
          'name': 'Dua Lipa',
          'genre': 'Pop/Dance',
          'followers': 71000000,
          'imageUrl': '',
        },
      ];

      print('🎤 Adding sample artists to Firestore...');

      for (var artist in sampleArtists) {
        await firestore.collection('Artists').add(artist);
        print('✅ Added artist: ${artist['name']} (${artist['genre']})');
      }

      print('🎉 All sample artists added successfully!');
    } catch (e) {
      print('❌ Error adding sample artists: $e');
    }
  }

  static Future<void> addSamplePodcasts() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      
      List<Map<String, dynamic>> samplePodcasts = [
        {
          'title': 'The Joe Rogan Experience',
          'host': 'Joe Rogan',
          'duration': '180:00',
          'releaseDate': Timestamp.now(),
          'description': 'Long form conversations with interesting people',
        },
        {
          'title': 'This American Life',
          'host': 'Ira Glass',
          'duration': '60:00',
          'releaseDate': Timestamp.now(),
          'description': 'Stories of American life',
        },
        {
          'title': 'Serial',
          'host': 'Sarah Koenig',
          'duration': '45:00',
          'releaseDate': Timestamp.now(),
          'description': 'True crime podcast investigating one story',
        },
        {
          'title': 'TED Talks Daily',
          'host': 'TED',
          'duration': '20:00',
          'releaseDate': Timestamp.now(),
          'description': 'Ideas worth spreading from TED conferences',
        },
      ];

      print('🎙️ Adding sample podcasts to Firestore...');

      for (var podcast in samplePodcasts) {
        await firestore.collection('Podcasts').add(podcast);
        print('✅ Added podcast: ${podcast['title']} by ${podcast['host']}');
      }

      print('🎉 All sample podcasts added successfully!');
    } catch (e) {
      print('❌ Error adding sample podcasts: $e');
    }
  }

  static Future<void> addAllSampleData() async {
    print('🚀 Adding all sample data to Firestore...');
    await addSampleSongs();
    await addSampleVideos();
    await addSampleArtists();
    await addSamplePodcasts();
    print('🎉 All sample data added successfully!');
  }

  static Future<void> checkFirestoreConnection() async {
    try {
      print('🔍 Checking Firestore connection...');

      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      
      final QuerySnapshot songsSnapshot =
          await firestore.collection('Songs').limit(1).get();

      print(
          '📦 Songs collection exists: ${songsSnapshot.docs.length} documents found');

     
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
