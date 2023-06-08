import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifechangerapp/register_pages/login_page.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors/colors.dart';
import 'home_pages/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var token;
  _session() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setBool("session", null);
    //prefs.setString("session_token", "firsttime");
    //sess = prefs.getBool("session")!;
    //print("Session Bool: " + sess.toString());
    token = prefs.getString("session_token");
    var sName = prefs.getString("user_name");
    print("Sess token: " + token.toString());
    if (token == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Home(token, sName),
          ),
          (route) => false);
    }
    // if (sess!) {
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(
    //         builder: (context) => MyApp(token),
    //       ),
    //       (route) => false);
    // } else {
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(
    //         builder: (context) => LoginPage(),
    //       ),
    //       (route) => false);
    // }
  }

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => setState(() {
        _session();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.purple,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                children: [
                  Center(
                    child: Lottie.asset("assets/lottie/circle.json",
                        height: 300, width: 350, repeat: false),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 35),
                      child: Lottie.asset("assets/lottie/lifechanger.json",
                          height: 250, width: 250, repeat: false),
                    ),
                  ),
                ],
              ),
            ),
            TextLiquidFill(
              text: 'Our Life Changer',
              boxBackgroundColor: Mycolors.purple,
              boxHeight: 120,
              waveColor: Mycolors.yellow,
              loadDuration: const Duration(seconds: 3),
              waveDuration: const Duration(seconds: 2),
              textStyle: const TextStyle(
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
