import 'package:flutter/material.dart';
import 'package:voter_finder/data/model/votar_model.dart';
import 'package:voter_finder/screen/votar/widget/votar_list_view.dart';
import 'package:voter_finder/utill/color_resources.dart';

import '../../data/helper/database_helper.dart';

class VotarListScreen extends StatefulWidget {
  List<VotarDataModel> votarDataList;
  VotarListScreen(this.votarDataList);

  @override
  _VotarListScreenState createState() => _VotarListScreenState();
}

class _VotarListScreenState extends State<VotarListScreen> {

  String convertToBanglaNumber(String englishNumber) {
    Map<String, String> digitMap = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    };

    String banglaNumber = '';

    for (int i = 0; i < englishNumber.length; i++) {
      String digit = englishNumber[i];
      banglaNumber += digitMap[digit] ?? digit;
    }

    return banglaNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Align(
            alignment: Alignment.centerLeft,
            child: Text('ভোটার সমূহ',style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25 / MediaQuery.textScaleFactorOf(context), color: Colors.white))),
      ),
      body:Column(
        children: [
          SizedBox(height: 8,),
          Expanded(
            child: ListView.builder(
              itemCount: widget.votarDataList.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                return VotarListView(widget.votarDataList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}