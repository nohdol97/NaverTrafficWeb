import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '/models/user_provider.dart';
import '/screen/login_page.dart';
import '/screen/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD5AGKNuIahPGbqV77YOaGmDe4zYq9TkFM",
      authDomain: "navertrafficweb-fed26.firebaseapp.com",
      projectId: "navertrafficweb-fed26",
      storageBucket: "navertrafficweb-fed26.appspot.com",
      messagingSenderId: "453423599082",
      appId: "1:453423599082:web:ce2c2177ee5ca201ed7693",
    ),
  );

  // Firestore 오프라인 지원 활성화
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  // 네트워크 상태를 강제로 온라인으로 설정
  FirebaseFirestore.instance.enableNetwork().then((_) {
    print("Network enabled");
  }).catchError((error) {
    print("Failed to enable network: $error");
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..autoLogin()),
      ],
      child: Consumer<UserProvider>(
        builder: (ctx, userProvider, _) {
          return MaterialApp(
            title: 'Web Dashboard',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: userProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : userProvider.userDoc != null ? MainPage() : LoginPage(),
          );
        },
      ),
    );
  }
}