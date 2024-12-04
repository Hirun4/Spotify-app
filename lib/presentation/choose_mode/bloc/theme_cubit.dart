import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  // Update theme
  void updateTheme(ThemeMode themeMode) => emit(themeMode);

  // Serialize state
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values[json['theme'] as int];
  }

  // Deserialize state
  @override
  Map<String, dynamic> toJson(ThemeMode state) {
    return {'theme': state.index};
  }
}
