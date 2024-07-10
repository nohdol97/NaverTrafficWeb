import 'package:flutter/material.dart';

class NoticePage extends StatelessWidget {
  final List<Map<String, String>> notices = [
    {"id": "100014", "title": "SPLIT 에 오신 것을 환영합니다.", "date": "2024-07-10"},
    // 추가 공지사항...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항'),
      ),
      body: ListView.builder(
        itemCount: notices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notices[index]['title']!),
            subtitle: Text(notices[index]['date']!),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // 공지사항 상세 페이지로 이동
            },
          );
        },
      ),
    );
  }
}
