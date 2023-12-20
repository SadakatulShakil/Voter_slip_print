import 'package:flutter/material.dart';
import 'package:voter_finder/data/model/votar_model.dart';
import 'package:voter_finder/screen/votar/votar_details_screen.dart';

import '../../../utill/color_resources.dart';

class VotarListView extends StatelessWidget {
  VotarDataModel votarDataList;
  VotarListView(this.votarDataList);


  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=> VotarDetailsScreen(votarDataList)
        ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: primaryColor.withOpacity(0),
        child: ListTile(
          title: Text(votarDataList.info.replaceAll('<br>', '\n'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
          // subtitle: Column(
          //   children: [
          //     Align(
          //       alignment: Alignment.centerLeft,
          //         child: Text('কেন্দ্রঃ '+votarDataList.center_name, style: TextStyle(color: Colors.white),)),
          //     Align(
          //         alignment: Alignment.centerLeft,
          //         child: Text('সিরিয়াল নংঃ '+votarDataList.serial, style: TextStyle(color: Colors.white),)),
          //     Align(
          //         alignment: Alignment.centerLeft,
          //         child: Text('হোল্ডিংঃ '+votarDataList.holding, style: TextStyle(color: Colors.white),)),
          //   ],
          // ),
          // trailing: Text('জন্ম তারিখঃ '+votarDataList.dob, style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
