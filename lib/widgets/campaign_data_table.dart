import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CampaignDataTable extends StatelessWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> campaigns;

  CampaignDataTable({required this.columns, required this.campaigns});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns.map((column) => DataColumn(label: Text(column))).toList(),
        rows: campaigns.map((campaign) {
          return DataRow(
            cells: columns.map((column) {
              var value = campaign[column];
              if (column == '시작일' || column == '종료일') {
                value = DateFormat('yyyy-MM-dd').format(value);
              }
              return DataCell(Text(value.toString()));
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
