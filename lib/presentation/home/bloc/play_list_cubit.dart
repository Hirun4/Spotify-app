import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/song/get_play_list.dart';
import '../../../service_locator.dart';
import 'play_list_state.dart';

class PlayListCubit extends Cubit<PlayListState> {
  PlayListCubit() : super(PlayListLoading());

  Future<void> getPlayList() async {
    print('🎵 PlayListCubit: Starting to get playlist...');
    var returnedSongs = await sl<GetPlayListUseCase>().call();

    returnedSongs.fold((error) {
      print('❌ PlayListCubit: Error occurred - $error');
      emit(PlayListLoadFailure(message: error.toString()));
    }, (data) {
      print('✅ PlayListCubit: Successfully loaded ${data.length} songs');
      emit(PlayListLoaded(songs: data));
    });
  }
}
