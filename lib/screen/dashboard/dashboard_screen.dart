import 'package:flutter/material.dart';
import 'package:voter_finder/data/model/area_wise_model.dart';
import 'package:voter_finder/data/model/centre_wise_model.dart';
import 'package:voter_finder/data/model/info_model.dart';
import 'package:voter_finder/utill/color_resources.dart';

import '../../data/helper/database_helper.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  // Sample data
  List<DashInfoModel> _infoList = [];
  List<AreaWiseDataModel> _areaWiseList = [];
  List<CenterWiseDataModel> _centreWiseList = [];

  Future<void> _loadInfo() async {
    final infoData = await DatabaseHelper.instance.getAllInfoData();
    setState(() {
      _infoList = infoData.toList();
      print("name_data_length: " + _infoList.length.toString());

    });
  }
  Future<void> _loadAreaWiseData() async {
    final areaWiseVotersData = await DatabaseHelper.instance.getAllAreaWiseData();
    setState(() {
      _areaWiseList = areaWiseVotersData.toList();
      print("areaWiseVotersData_length: " + _areaWiseList.length.toString());
      print("areaWiseVotersData: " + _areaWiseList.map((votar) => votar.name).join(', '));

    });
  }
  Future<void> _loadCentreWiseData() async {
    final centerWiseVotersData = await DatabaseHelper.instance.getAllCenterWiseData();
    setState(() {
      _centreWiseList = centerWiseVotersData.toList();
      print("centerWiseVotersData_length: " + _centreWiseList.length.toString());
      print("centerWiseVotersData: " + _centreWiseList.map((votar) => votar.name).join(', '));

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadInfo();
    _loadAreaWiseData();
    _loadCentreWiseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text("ড্যাসবোর্ড"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Total Count, Migrate Count, Subtotal Count
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('তথ্য', style: TextStyle(color: Colors.blueAccent, fontSize: 24, fontWeight: FontWeight.w600),),
            ),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("মোট ভোটার",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),
                      Text(_infoList.single.total_voters??'',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16)),
                    ],
                  ),
                  Divider(thickness: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("মাইগ্রেট সহ মোট ভোটার", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 16)),
                      Text(_infoList.single.total_voters_with_migrate??'', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16)),
                    ],
                  ),
                  Divider(thickness: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("মোট কেন্দ্র", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),
                      Text(_infoList.single.total_centers??'', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16)),
                    ],
                  ),
                  Divider(thickness: 2,),
                ],
              ),
            ),
            SizedBox(height: 8,),
            // Area Wise Table
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('এলাকা ভিত্তিক ভোটার সংখ্যা', style: TextStyle(color: Colors.blueAccent, fontSize: 24, fontWeight: FontWeight.w600),),
            ),
            SizedBox(height: 8,),
        Container(
          padding: EdgeInsets.all(2.0),
          child: DataTable(
            headingRowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              return Colors.teal.shade200;
            }),
            columnSpacing: 10.0,
            border: TableBorder.all(
              width: 1,
            ),// Adjust the spacing between columns if needed
            columns: [
              DataColumn(label: Text("এলাকা", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
              DataColumn(label: Text("পুরুষ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
              DataColumn(label: Text("মহিলা", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
              DataColumn(label: Text("মোট", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
            ],
            rows: _areaWiseList.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              final isOdd = index.isOdd;
              final rowColor = isOdd ? Colors.grey[200] : Colors.white;

              return DataRow(
                color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  return rowColor!;
                }),
                cells: [
                  DataCell(
                    Container(
                      width: 150, // Width for the first column (এলাকা)
                      child: Text(data.name),
                    ),
                  ),
                  DataCell(Text(data.male_voters)),
                  DataCell(Text(data.female_voters)),
                  DataCell(
                    Text(
                      ((int.tryParse(data.male_voters) ?? 0) + (int.tryParse(data.male_voters) ?? 0)).toString(),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),

            SizedBox(height: 18,),
        Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('কেন্দ্র ভিত্তিক ভোটার সংখ্যা', style: TextStyle(color: Colors.blueAccent, fontSize: 24, fontWeight: FontWeight.w600),),
            ),
            SizedBox(height: 8,),
            // Centre Wise Table
            Container(
              padding: EdgeInsets.all(2.0),
              child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  return Colors.teal.shade200;
                }),
                columnSpacing: 10.0,
                border: TableBorder.all(
                  width: 1,
                ),// Adjust the spacing between columns if needed
                columns: [
                  DataColumn(label: Text("কেন্দ্র", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("থেকে",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("পর্যন্ত", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("মোট", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                ],
                rows: _centreWiseList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  final isOdd = index.isOdd;
                  final rowColor = isOdd ? Colors.grey[200] : Colors.white;

                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      return rowColor!;
                    }),
                    cells: [
                      DataCell(Container(
                        width: 150, // Width for the first column (এলাকা)
                        child: Text(data.name),
                      )),
                      DataCell(Text(data.from)),
                      DataCell(Text(data.to)),
                      DataCell(
                        Text(
                          (((int.tryParse(data.to) ?? 0) - (int.tryParse(data.from) ?? 0))+1).toString(),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
