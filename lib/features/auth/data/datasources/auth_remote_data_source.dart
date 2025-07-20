import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        return UserModel.fromFirebaseUser(result.user!);
      } else {
        throw const AuthException('Login failed');
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Login failed');
    }
  }

  @override
  Future<UserModel> register(String email, String password) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        return UserModel.fromFirebaseUser(result.user!);
      } else {
        throw const AuthException('Registration failed');
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration failed');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Logout failed');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        return UserModel.fromFirebaseUser(user);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Failed to get current user');
    }
  }
}