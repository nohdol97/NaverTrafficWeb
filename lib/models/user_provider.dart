import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentSnapshot? _userDoc;

  DocumentSnapshot? get userDoc => _userDoc;

  // Cloud Firestore 에서 users 컬렉션 만들어야 함.
  // DataStore 로 들어가지는 경우 네이티브 시작할 수 있게 해야 함.
  // 못찾겠으면 DataStore 상단 오른쪽에 콘솔에 아래 입력
  // gcloud beta firestore databases update --type=firestore-native
  Future<void> loadUserData() async {
    if (_auth.currentUser != null) {
      _userDoc = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
      notifyListeners();
    }
  }
}
