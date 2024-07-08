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

  List<Map<String, dynamic>> getFilteredCampaigns(List<Map<String, dynamic>> campaigns) {
    String searchText = searchController.text.toLowerCase();
    return campaigns.where((campaign) {
      var value = campaign[searchColumn]?.toString().toLowerCase() ?? '';
      return value.contains(searchText);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var columns = ['식별번호', '상태', '총판', '대행사', '셀러', '메인 키워드', '서브 키워드', '상품 URL', 'MID값', '원부 URL', '원부 MID값', '시작일', '종료일', '유입수'];

    return Scaffold(
      appBar: AppBar(
        title: Text('캠페인'),
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file, color: Colors.green),
            onPressed: () => ExcelService.uploadFile(context),
          ),
          SizedBox(width: 25,),
        ],
      ),
      body: Consumer<CampaignProvider>(
        builder: (context, campaignProvider, child) {
          List<Map<String, dynamic>> filteredCampaigns = getFilteredCampaigns(campaignProvider.campaigns);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: custom.SearchBar(
                  columns: columns,
                  searchColumn: searchColumn,
                  searchController: searchController,
                  onSearchColumnChanged: (value) {
                    setState(() {
                      searchColumn = value;
                    });
                  },
                  onSearchTextChanged: (text) {
                    setState(() {}); // Trigger a rebuild to filter the campaigns
                  },
                ),
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