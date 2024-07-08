import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalStorage storage = LocalStorage('user_data');
  DocumentSnapshot? _userDoc;
  bool isLoading = true;

  DocumentSnapshot? get userDoc => _userDoc;

  Future<void> loadUserData() async {
    if (_auth.currentUser != null) {
      try {
        _userDoc = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
        notifyListeners();
      } catch (e) {
        print('Failed to load user data: $e');
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await loadUserData();

      // LocalStorage에 로그인 정보 저장
      await storage.ready;
      await storage.setItem('email', email);
      await storage.setItem('password', password);
      print('Login successful, stored credentials: $email');
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Login failed: $e');
      isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    this._userDoc = null;
    notifyListeners();

    // LocalStorage에서 로그인 정보 삭제
    await storage.ready;
    await storage.deleteItem('email');
    await storage.deleteItem('password');
  }

  Future<void> autoLogin() async {
    print('Attempting auto-login');
    await storage.ready;
    String? email = storage.getItem('email');
    String? password = storage.getItem('password');

    if (email != null && password != null) {
      try {
        print('Stored credentials found: $email');
        await login(email, password);
      } catch (e) {
        print('Auto-login failed: $e');
      }
    } else {
      print('No stored credentials found');
      isLoading = false;
      notifyListeners();
    }
  }
}