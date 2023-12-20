import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voter_finder/screen/home/home_screen.dart';
import 'package:voter_finder/screen/home/widget/bottom_cart_view.dart';
import 'package:voter_finder/screen/home/widget/dashboard_view.dart';
import 'package:voter_finder/screen/login/widget/text_from_field.dart';

import '../../utill/color_resources.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Image.asset('assets/images/print_banner1.png'),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  width: 300,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade200, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'স্বাগতম',
                          style: TextStyle(fontSize: 24 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.bold, color: accent),
                        ),
                      ),
                      Text(
                        'আইডি ও পাসওয়ার্ড দিয়ে লগইন করুন',
                        style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.bold, color: accent),
                      ),
                      SizedBox(height: 20),
                      GetTextFormField(
                        //onChangeText: dataProvider.updateTextFieldUsersEmail,
                        controller: emailController,
                        hintName: "আইডি",
                        inputType: TextInputType.emailAddress,
                      ),
                      GetTextFormField(
                        controller: passwordController,
                        hintName: 'পাসওয়ার্ড',
                        inputType: TextInputType.text,
                        isObscureText: true,
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () async{
                            // Implement sign-in logic here
                            if(emailController.text == 'manjur.alam' && passwordController.text == 'manjur112233'){
                              // Obtain shared preferences.
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setString('isLogged', 'logged');
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomeScreen()),
                                      (route) => false);
                            }else{
                              Get.snackbar(
                                'দুঃখিত বার্তা!',
                                'আইডি অথবা পাসওয়ার্ড ভুল হয়েছে !',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                                borderRadius: 10,
                                margin: EdgeInsets.all(10),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(

                            primary: accent, // Set the background color here
                          ),
                          child: Text('লগইন', style: TextStyle(color: Colors.white, fontSize: 16 / MediaQuery.textScaleFactorOf(context))),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       '@ Powered by ',
                      //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                      //     ),
                      //     GestureDetector(
                      //       onTap: (){
                      //         final Uri _url = Uri.parse('https://flutter.dev');
                      //         launchURL(_url);
                      //       },
                      //       child: Text(
                      //         'Solution Clime',
                      //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: accent),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

