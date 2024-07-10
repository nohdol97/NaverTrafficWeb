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
    isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await loadUserData();

      await storage.ready;
      await storage.setItem('email', email);
      await storage.setItem('password', password);
      print('Login successful, stored credentials: $email');
    } catch (e) {
      print('Login failed: $e');
      throw e;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _userDoc = null;
    await storage.ready;
    await storage.deleteItem('email');
    await storage.deleteItem('password');
    notifyListeners();
  }

  Future<void> autoLogin() async {
    isLoading = true;
    notifyListeners();
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