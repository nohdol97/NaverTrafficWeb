import 'package:firebase_storage/firebase_storage.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class ExcelService {
  static Future<List<Map<String, dynamic>>> loadExcelData(String userName, String userRole) async {
    final ref = FirebaseStorage.instance.ref().child('data.xlsx');
    final url = await ref.getDownloadURL();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var bytes = response.bodyBytes;
      var excel = Excel.decodeBytes(bytes);
      List<Map<String, dynamic>> campaigns = [];

      DateTime currentDate = DateTime.now();

      for (var table in excel.tables.keys) {
        if (excel.tables[table] != null) {
          var sheet = excel.tables[table]!;
          for (var row in sheet.rows.skip(1)) {
            if (row.length < 13) continue;

            String? startDateString = row[10]?.value?.toString();
            String? endDateString = row[11]?.value?.toString();
            DateTime startDate;
            DateTime endDate;

            try {
              startDate = DateFormat('yyyy-MM-dd').parse(startDateString ?? '2000-01-01');
            } catch (e) {
              startDate = DateTime(2000, 1, 1);
            }

            try {
              endDate = DateFormat('yyyy-MM-dd').parse(endDateString ?? '2000-01-01');
            } catch (e) {
              endDate = DateTime(2000, 1, 1);
            }

            String status;
            if (currentDate.isBefore(startDate)) {
              status = '시작전';
            } else if (currentDate.isAfter(endDate)) {
              status = '종료';
            } else {
              status = '구동중';
            }

            Map<String, dynamic> campaign = {
              '식별번호': row[0]?.value?.toString() ?? '',
              '상태': status,
              '총판': row[1]?.value?.toString() ?? '',
              '대행사': row[2]?.value?.toString() ?? '',
              '셀러': row[3]?.value?.toString() ?? '',
              '메인 키워드': row[4]?.value?.toString() ?? '',
              '서브 키워드': row[5]?.value?.toString() ?? '',
              '상품 URL': row[6]?.value?.toString() ?? '',
              'MID값': row[7]?.value?.toString() ?? '',
              '원부 URL': row[8]?.value?.toString() ?? '',
              '원부 MID값': row[9]?.value?.toString() ?? '',
              '시작일': startDate,
              '종료일': endDate,
              '유입수': row[12]?.value?.toString() ?? '0',
            };

            if (userRole == 'master' ||
                (userRole == '총판' && row[1]?.value == userName) ||
                (userRole == '대행사' && row[2]?.value == userName) ||
                (userRole == '셀러' && row[3]?.value == userName)) {
              campaigns.add(campaign);
            }
          }
        }
      }

      return campaigns;
    } else {
      throw Exception('Failed to load Excel data: ${response.statusCode}');
    }
  }

  static Future<void> uploadFile(BuildContext context, Function loadExcelData) async {
    try {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = '.xlsx';
      uploadInput.click();

      uploadInput.onChange.listen((event) async {
        final files = uploadInput.files;
        if (files!.isNotEmpty) {
          final file = files[0];
          final reader = html.FileReader();

          reader.onLoadEnd.listen((event) async {
            final fileBytes = reader.result as Uint8List;

            final ref = FirebaseStorage.instance.ref().child('data.xlsx');
            final url = await ref.getDownloadURL();
            final response = await http.get(Uri.parse(url));

            if (response.statusCode == 200) {
              var existingBytes = response.bodyBytes;
              var existingExcel = Excel.decodeBytes(existingBytes);
              var newExcel = Excel.decodeBytes(fileBytes);

              var existingSheet = existingExcel.tables[existingExcel.tables.keys.first]!;
              var newSheet = newExcel.tables[newExcel.tables.keys.first]!;

              int currentMaxIdentifier = existingSheet.maxRows - 1; // 현재 식별번호 최대값

              // 새 데이터 추가
              for (var row in newSheet.rows.skip(1)) {
                List<String> newRow = [];
                currentMaxIdentifier++;
                newRow.add(currentMaxIdentifier.toString()); // 식별번호 추가
                for (var cell in row) {
                  newRow.add(cell?.value?.toString() ?? '');
                }
                existingSheet.insertRowIterables(newRow, existingSheet.maxRows);
              }

              var encodedBytes = Uint8List.fromList(existingExcel.encode()!);
              await ref.putData(encodedBytes);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('파일 업로드 성공')),
              );

              loadExcelData();
            } else {
              throw Exception('Failed to load existing Excel data: ${response.statusCode}');
            }
          });

          reader.readAsArrayBuffer(file);
        }
      });
    } catch (e) {
      print('Failed to upload file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('파일 업로드 실패: $e')),
      );
    }
  }
}