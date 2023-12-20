import 'package:flutter/material.dart';

import '../../utill/color_resources.dart';
class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('আমাদের সম্পর্কে'),
        backgroundColor: accent,
      ),
        backgroundColor: primaryBackground,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Image.asset('assets/images/aboutus.png'),
              SizedBox(height: 20),
             Text('About US', style: TextStyle(fontSize: 24, color: Colors.blue[800], fontWeight: FontWeight.bold),),
              SizedBox(height: 20),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text('At Solution Clime, we bring three years of valuable experience to every project we undertake. Over this time, we have honed our skills, expanded our knowledge, and refined our processes to deliver exceptional web solutions for our clients.'),
             ),
              SizedBox(height: 30),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text('Our experience has equipped us with the expertise to tackle complex projects, navigate emerging trends, and implement cutting-edge technologies. We have witnessed firsthand how the digital landscape has evolved, and we continually adapt and innovate to stay ahead of the curve.'),
             ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                    child: Text('Phone Number \n+88 017 2972 0055')),
              ),
              SizedBox(height: 20),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Align(
                   alignment: Alignment.centerLeft,
                   child: Text('Email Address \ninfo@solutionclime.com')),
             ),
            ],
          ),
        ));
  }
}

