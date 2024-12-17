import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/presentation/home/bloc/news_songs_cubit.dart';

import '../bloc/news_songs_state.dart';

class NewsSongs extends StatelessWidget {
  const NewsSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsSongsCubit(),
      child: SizedBox(
          height: 200,
          child: BlocBuilder<NewsSongsCubit, NewsSongsState>(
            builder: (context, State) {
              if (State is NewsSongsLoading) {
                return CircularProgressIndicator();
              }
              if (State is NewsSongsLoaded) {
                return _songs();
              }
              return Container();
            },
          )),
    );
  }

  Widget _songs() {
    return ListView.separated(
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder,
        itemCount: itemCount);
  }
}
