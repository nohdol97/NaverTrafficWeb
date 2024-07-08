import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final List<String> columns;
  final String searchColumn;
  final TextEditingController searchController;
  final Function(String) onSearchColumnChanged;
  final Function(String) onSearchTextChanged;

  SearchBar({
    required this.columns,
    required this.searchColumn,
    required this.searchController,
    required this.onSearchColumnChanged,
    required this.onSearchTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Spacer(),
          SizedBox(
            width: 150, // 적당한 크기로 설정
            child: DropdownButton<String>(
              isExpanded: true,
              value: searchColumn,
              onChanged: (String? newValue) {
                onSearchColumnChanged(newValue!);
              },
              items: columns.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SizedBox(width: 8), // Dropdown과 TextField 사이 간격
          SizedBox(
            width: 300, // 적당한 크기로 설정
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: '검색',
                border: OutlineInputBorder(),
              ),
              onChanged: onSearchTextChanged,
            ),
          ),
        ],
      ),
    );
  }
}
