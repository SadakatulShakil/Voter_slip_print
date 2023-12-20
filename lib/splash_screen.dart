import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:voter_finder/utill/color_resources.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> _doSessionTask ()async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? session = prefs.getString('isLogged');
    Timer(Duration(seconds: 3), () {
      if(session != 'logged'){
        Navigator.pushReplacementNamed(context, '/auth');
      }else{
        Navigator.pushReplacementNamed(context, '/home');
      }

    });
  }
  @override
  void initState() {
    super.initState();
    _doSessionTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash.png', height: 200,width: 200,),
            SizedBox(height: 20,),
            Text('মনজুর আলম-ভোটার তথ্য', style: TextStyle(fontSize: 18 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.bold, color: accent),)
          ],
        ),
      ),
    );

  }


}
