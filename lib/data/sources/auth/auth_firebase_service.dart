abstract class AuthFirebaseService {
  Future<void> signup();
  Future<void> signin();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<void> signin() {
    // TODO: implement signin
    throw UnimplementedError();
  }

  @override
  Future<void> signup() {
    // TODO: implement signup
    throw UnimplementedError();
  }
}
