import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_finder/screen/login/login_screen.dart';

import '../../../utill/color_resources.dart';
import '../../dashboard/dashboard_screen.dart';
import '../about_screen.dart';

class DrawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            // Image
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/print_banner1.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // Green Shadow
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              color:
              primaryColor.withOpacity(0.8), // Semi-transparent green color
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: ListTile(
            leading: Icon(Icons.home),
            title: Text('হোম', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
          ),
        ),
        // GestureDetector(
        //   onTap: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => DashBoardPage()));
        //   },
        //   child: ListTile(
        //     leading: Icon(Icons.menu_book_rounded),
        //     title: Text('ড্যাসবোর্ড'),
        //   ),
        // ),
        // GestureDetector(
        //   onTap: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => AboutScreen()));
        //   },
        //   child: ListTile(
        //     leading: Icon(Icons.support_agent_rounded),
        //     title: Text('আমাদের সম্পর্কে'),
        //   ),
        // ),
        // GestureDetector(
        //   onTap: () {
        //     Navigator.pop(context);
        //     // Navigator.push(
        //     //     context,
        //     //     MaterialPageRoute(builder: (context) => NewOrderScreen()));
        //   },
        //   child: ListTile(
        //     leading: Icon(Icons.privacy_tip),
        //     title: Text('প্রাইভেসি পলিসি'),
        //   ),
        // ),
        // GestureDetector(
        //   onTap: () {
        //     Navigator.pop(context);
        //     // Navigator.push(
        //     //     context,
        //     //     MaterialPageRoute(builder: (context) => TotalDeliveryScreen()));
        //   },
        //   child: ListTile(
        //     leading: Icon(Icons.share),
        //     title: Text('শেয়ার করুন'),
        //   ),
        // ),
        GestureDetector(
          onTap: () async{
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false);
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('isLogged', '');
          },
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('প্রস্থান', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
          ),
        ),
      ],
    );
  }
}