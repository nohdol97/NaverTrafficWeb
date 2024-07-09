import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_provider.dart';
import 'dashboard_page.dart';
import 'notice_page.dart';
import 'campaign_page.dart';
import 'register_page.dart';
import 'login_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    DashboardPage(),
    NoticePage(),
    CampaignPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var userDoc = userProvider.userDoc;

    // Firestore에서 가져온 문서의 데이터를 Map으로 변환
    var userData = userDoc?.data() as Map<String, dynamic>?;

    String userName = userData?['name'] ?? 'Unknown User';
    String userRole = userData?['role'] ?? 'Unknown Role';

    return Scaffold(
      appBar: AppBar(
        title: Text('SPLIT ) $userName 님 환영합니다.'),
        actions: [
          if (userRole == 'SuperMaster' || userRole == 'master')
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                '등록하기',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          TextButton(
            onPressed: () async {
              await Provider.of<UserProvider>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text(
              '로그아웃',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu - $userName'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('공지사항'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('캠페인'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}