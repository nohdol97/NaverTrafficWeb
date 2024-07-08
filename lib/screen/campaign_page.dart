import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/campaign_provider.dart';
import '../models/user_provider.dart';
import '../services/excel_service.dart';
import '../widgets/campaign_data_table.dart';
import '../widgets/search_bar.dart' as custom;

class CampaignPage extends StatefulWidget {
  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  List<Map<String, dynamic>> filteredCampaigns = [];
  String searchColumn = '식별번호';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load the campaigns data
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final campaignProvider = Provider.of<CampaignProvider>(context, listen: false);
    campaignProvider.loadInitialData(userProvider.userDoc!['name'], userProvider.userDoc!['role']);
  }

  void filterCampaigns(String searchText) {
    searchText = searchText.toLowerCase();
    setState(() {
      filteredCampaigns = Provider.of<CampaignProvider>(context, listen: false).campaigns.where((campaign) {
        var value = campaign[searchColumn].toString().toLowerCase();
        return value.contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var columns = ['식별번호', '상태', '총판', '대행사', '셀러', '메인 키워드', '서브 키워드', '상품 URL', 'MID값', '원부 URL', '원부 MID값', '시작일', '종료일', '유입수'];

    return Scaffold(
      appBar: AppBar(
        title: Text('캠페인'),
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: () => ExcelService.uploadFile(context),
          ),
        ],
      ),
      body: Consumer<CampaignProvider>(
        builder: (context, campaignProvider, child) {
          filteredCampaigns = campaignProvider.campaigns;
          return Column(
            children: [
              custom.SearchBar(
                columns: columns,
                searchColumn: searchColumn,
                searchController: searchController,
                onSearchColumnChanged: (value) {
                  setState(() {
                    searchColumn = value;
                  });
                },
                onSearchTextChanged: filterCampaigns,
              ),
              Expanded(
                child: CampaignDataTable(columns: columns, campaigns: filteredCampaigns),
              ),
            ],
          );
        },
      ),
    );
  }
}
