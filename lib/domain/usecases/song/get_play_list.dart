import 'package:dartz/dartz.dart';
import 'package:spotify_app/core/usecase/usecase.dart';

import 'package:spotify_app/data/repository/song/song_repository_impl.dart';

import '../../../service_locator.dart';

class GetPlayListUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<SongRepositoryImpl>().getPlayList();
  }
}
