import 'dart:math';
import 'package:flutter/material.dart';
import 'package:voter_finder/screen/home/widget/bottom_cart_view.dart';
import 'package:voter_finder/screen/home/widget/dashboard_view.dart';

import '../../utill/color_resources.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // MediaQueryData mediaQuery = MediaQuery.of(context);
    // double devicePixelRatio = mediaQuery.devicePixelRatio;
    //print('ratio : '+ devicePixelRatio.toString());
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: Text('স্বাগতম', style: TextStyle(fontSize: 30 / MediaQuery.textScaleFactorOf(context)),),
          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        drawer: Drawer(
          child: DrawerContent(),
        ),
        bottomNavigationBar: BottomCartView(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/marka_home.jpeg')
            ],
          ),
        ));
  }
}

