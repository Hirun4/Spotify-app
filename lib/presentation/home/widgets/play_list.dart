import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/common/helpers/is_dark_mode.dart';
import 'package:spotify_app/core/configs/theme/app_colors.dart';
import 'package:spotify_app/domain/entities/song/song.dart';
import 'package:spotify_app/presentation/home/bloc/play_list_cubit.dart';

import '../bloc/play_list_state.dart';

class PlayList extends StatelessWidget {
  const PlayList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayListCubit()..getPlayList(),
      child: BlocBuilder<PlayListCubit,PlayListState>(
        builder:(context,state) {
          if(state is PlayListLoading){
            return Container(
              alignment: Alignment.center,
              child:const CircularProgressIndicator(),
            );
          }
          if(state is PlayListLoaded){
            return const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 16
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Playlist',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
              
                      Text(
                        'See More',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xffc6c6c6)
                        ),
                      ),
                    ],
                  ),
                  //_songs(context)
                ],
              ),
            );
          }

          return Container();
        },
      )
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      itemBuilder: (context,index){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.isDarkMode ? AppColors.darkGrey : Color(0xffE6E6E6)

                  ),
                )
              ],
            )
          ],
        );

      }, 
      separatorBuilder: (context,index) => const SizedBox(height: 10,), 
      itemCount: songs.length
      );

  }
}