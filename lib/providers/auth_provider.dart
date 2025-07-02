import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool _isLoading = true;

  AuthProvider() {
    _auth.authStateChanges().listen((User? newUser) {
      user = newUser;
      _isLoading = false;
      notifyListeners();
    });
  }

  bool get isLoggedIn => user != null;
  bool get isLoading => _isLoading;

  Future<void> register(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
