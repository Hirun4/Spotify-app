import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify_app/core/configs/constants/app_urls.dart';
import 'package:spotify_app/data/models/auth/create_user_req.dart';
import 'package:spotify_app/data/models/auth/signin_user_req.dart';
import 'package:spotify_app/data/models/auth/user.dart';
import 'package:spotify_app/domain/entities/auth/user.dart';

abstract class AuthFirebaseService {
  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> signin(SigninUserReq signinUserReq);
  Future<Either> getUser();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try {
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: createUserReq.email, password: createUserReq.password);

      // Update the user's display name
      await data.user?.updateDisplayName(createUserReq.fullName);

      // Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(data.user?.uid)
          .set({'name': createUserReq.fullName, 'email': createUserReq.email});

      return const Right('Signup was successful ');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'án account already exist with that email';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: signinUserReq.email, password: signinUserReq.password);

      return const Right('Sigin was successful ');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'invalid email') {
        message = 'user not found';
      } else if (e.code == 'invalid credentials') {
        message = 'wrong password';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      print('🔍 Starting to get user profile...');
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        print('❌ No current user found');
        return const Left('User not authenticated');
      }

      print('👤 Current user UID: ${currentUser.uid}');

      var userDoc = await firebaseFirestore
          .collection('Users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        print('❌ User document does not exist in Firestore');
        return const Left('User profile not found');
      }

      print('📄 User document data: ${userDoc.data()}');

      UserModel userModel = UserModel.fromJson(userDoc.data()!);
      userModel.imageURL = currentUser.photoURL ?? AppURLs.defaultImage;

      print('✅ User model created: ${userModel.fullName}, ${userModel.email}');

      UserEntity userEntity = userModel.toEntity();
      return Right(userEntity);
    } catch (e) {
      print('❌ Error getting user profile: $e');
      print('📍 Stack trace: ${StackTrace.current}');
      return const Left('An error occurred');
    }
  }
}
