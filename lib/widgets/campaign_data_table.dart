import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

class CampaignDataTable extends StatelessWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> campaigns;

  CampaignDataTable({required this.columns, required this.campaigns});

  Widget _buildStatusCircle(String status) {
    Color color;
    switch (status) {
      case '종료':
        color = Colors.red;
        break;
      case '구동중':
        color = Colors.green;
        break;
      case '시작전':
        color = Colors.yellow;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  void _launchURL(String url) {
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: campaigns.map((campaign) {
        return Row(
          children: columns.map((column) {
            var value = campaign[column];
            if (column == '시작일' || column == '종료일') {
              value = DateFormat('yyyy-MM-dd').format(value);
            }
            if (column == '상품 URL' || column == '원부 URL') {
              return Container(
                width: 130, // 각 컬럼의 고정 너비
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _launchURL(value.toString());
                  },
                  child: Tooltip(
                    message: value.toString(),
                    child: Text(
                      value.toString().length > 30
                          ? value.toString().substring(0, 30) + '...'
                          : value.toString(),
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              );
            }
            if (column == '상태') {
              return Container(
                width: 130, // 각 컬럼의 고정 너비
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _buildStatusCircle(value.toString()),
                    SizedBox(width: 4),
                    Text(value.toString()),
                  ],
                ),
              );
            }
            return Container(
              width: 130, // 각 컬럼의 고정 너비
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(value.toString()),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}