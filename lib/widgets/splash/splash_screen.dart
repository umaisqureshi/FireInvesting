import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:MOT/shared/colors.dart';
import 'package:MOT/widgets/home.dart';
import 'package:MOT/widgets/login/login_section.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Timer(Duration(seconds: 5), () {
        loadData();
      });


    }
  }

  void loadData() {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => StockMarketAppHome()));
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginSection()));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kScaffoldBackground,
        body:     Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/icon.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Theme
                      .of(context)
                      .accentColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
