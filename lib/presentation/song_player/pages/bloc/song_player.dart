import 'package:flutter/material.dart';
import 'package:spotify_app/common/widgets/appbar/app_bar.dart';
import 'package:spotify_app/domain/entities/song/song.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;
  const SongPlayerPage({
    required this.songEntity,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: const Text(
          'Now playing',
          style: TextStyle(
            fontSize: 18
          ),
        ),
        action: IconButton(
          onPressed: (){}, 
          icon:const Icon(
            Icons.more_vert_rounded
          )
        ),
      ),
    );
  }
}