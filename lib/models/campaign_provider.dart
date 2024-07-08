import 'package:flutter/material.dart';
import '../services/excel_service.dart';

class CampaignProvider with ChangeNotifier {
  List<Map<String, dynamic>> _campaigns = [];

  List<Map<String, dynamic>> get campaigns => _campaigns;

  Future<void> loadInitialData(String userName, String userRole) async {
    _campaigns = await ExcelService.loadExcelData(userName, userRole);
    notifyListeners();
  }

  void setCampaigns(List<Map<String, dynamic>> campaigns) {
    _campaigns = campaigns;
    notifyListeners();
  }

  void clearCache() {
    ExcelService.clearCache();
    notifyListeners();
  }
}