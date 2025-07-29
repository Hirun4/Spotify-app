import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/domain/usecases/song/get_news_songs.dart';
import 'package:spotify_app/presentation/home/bloc/news_songs_state.dart';

import '../../../service_locator.dart';

class NewsSongsCubit extends Cubit<NewsSongsState> {
  NewsSongsCubit() : super(NewsSongsLoading());

  Future<void> getNewsSongs() async {
    print('🎵 NewsSongsCubit: Starting to get news songs...');
    var returnedSongs = await sl<GetNewsSongsUseCase>().call();

    returnedSongs.fold((error) {
      print('❌ NewsSongsCubit: Error occurred - $error');
      emit(NewsSongsLoadFailure(message: error.toString()));
    }, (data) {
      print('✅ NewsSongsCubit: Successfully loaded ${data.length} songs');
      emit(NewsSongsLoaded(songs: data));
    });
  }
}
