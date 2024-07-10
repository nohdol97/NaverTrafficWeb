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
            width: 150,
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
          SizedBox(width: 15),
          SizedBox(
            height: 50,  // 높이를 조정
            width: 150,  // 너비를 조정
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: '검색',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),  // 둥근 모서리
                  borderSide: BorderSide.none,  // 테두리 제거
                ),
                filled: true,  // 배경을 채움
                fillColor: Colors.grey[200],  // 배경 색상
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),  // 내용 패딩
              ),
              onChanged: onSearchTextChanged,
            ),
          ),
          SizedBox(width:100),
        ],
      ),
    );
  }
}