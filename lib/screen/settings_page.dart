import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final List<Map<String, String>> settings = [
    {"id": "105554", "title": "설정1", "description": "설명1"},
    {"id": "105556", "title": "설정2", "description": "설명2"},
    // 추가 설정...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: ListView.builder(
        itemCount: settings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(settings[index]['title']!),
            subtitle: Text(settings[index]['description']!),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // 설정 상세 페이지로 이동
            },
          );
        },
      ),
    );
  }
}
