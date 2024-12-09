import 'package:get_it/get_it.dart';
import 'package:spotify_app/data/sources/auth/auth_firebase_service.dart';

final sl = GetIt.instance;
Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
}
