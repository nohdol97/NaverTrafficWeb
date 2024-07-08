import 'package:flutter/material.dart';

class CampaignPage extends StatelessWidget {
  final List<Map<String, String>> campaigns = [
    {"id": "100018", "title": "캠페인1", "startDate": "2024-04-02", "endDate": "2024-04-11"},
    {"id": "100017", "title": "캠페인2", "startDate": "2024-03-27", "endDate": "2024-04-05"},
    // 추가 캠페인...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('캠페인'),
      ),
      body: ListView.builder(
        itemCount: campaigns.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(campaigns[index]['title']!),
            subtitle: Text('기간: ${campaigns[index]['startDate']} ~ ${campaigns[index]['endDate']}'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // 캠페인 상세 페이지로 이동
            },
          );
        },
      ),
    );
  }
}
