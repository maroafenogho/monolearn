import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:mono_learn/tools/user.dart';

class AuthService extends ChangeNotifier {
  bool isVisible = false;
  bool isLoading = false;
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    } else {
      return User(user.email, user.uid, user.emailVerified);
    }
  }
  

  void loading() {
    isLoading = !isLoading;
    print(isLoading);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  void toggleVisibility() {
    isVisible = !isVisible;
    notifyListeners();
    print('you  dey see am?');
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(credential.user);
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(credential.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
