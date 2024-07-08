import 'package:flutter/material.dart';

class RefundPage extends StatelessWidget {
  final List<Map<String, String>> refunds = [
    {"id": "100472", "title": "환불1", "startDate": "2024-03-19", "endDate": "2024-03-29"},
    {"id": "100473", "title": "환불2", "startDate": "2024-04-01", "endDate": "2024-04-10"},
    // 추가 환불...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('환불'),
      ),
      body: ListView.builder(
        itemCount: refunds.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(refunds[index]['title']!),
            subtitle: Text('기간: ${refunds[index]['startDate']} ~ ${refunds[index]['endDate']}'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // 환불 상세 페이지로 이동
            },
          );
        },
      ),
    );
  }
}
