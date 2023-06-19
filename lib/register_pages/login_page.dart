// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unrelated_type_equality_checks, unnecessary_new, prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lifechangerapp/api/fb_api.dart';
import 'package:lifechangerapp/colors/colors.dart';
import 'package:lifechangerapp/common/common_info.dart';
import 'package:lifechangerapp/common/custom_dialogue.dart';
import 'package:lifechangerapp/home_pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/google_signin_api.dart';
import '../api/webapi.dart';
import '../helper/theme_helper.dart';
import 'forgot_password_page.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  // const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 100;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = false;
  String? email;
  String? password;
  final _email = TextEditingController();
  final _password = TextEditingController();
  var response;

  var userName;
  var token, u_id;
  _socialResponseData() async {
    print("Inside social response");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CallApi _api = CallApi();
    var data = {
      'name': response.displayName,
      'email': response.email,
      'provider': "google",
      'provider_id': response.id,
    };
    var result = await _api.postData(data, 'login/social-response');
    var body = jsonDecode(result.body);
    token = body['data']['token'].toString();
    userName = body['data']['user_name'].toString();
    u_id = body['data']['id'].toString();
    print("Token in google: " + token);
    print("User Name in google: " + userName);
    print("Id in google: " + u_id);
    prefs.setString("session_token", token);
    prefs.setString("user_name", userName);
    prefs.setString("user_id", u_id);
    prefs.setInt("googleSign", 1);
    print("userID: " + prefs.getString("user_id").toString());
    print("google Response: " + body.toString());
    var sToken = prefs.getString("session_token");
    var sName = prefs.getString("user_name");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home(sToken, sName)));
  }

  Future googlesignIn() async {
    CustomProgressDialogue.progressDialogue(context);
    //progressDialogue(context);
    response = await GoogleSignInApi.login();

    print("loginnres" + response.toString());
    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signin Failed'),
        ),
      );
      Navigator.of(context, rootNavigator: true).pop('dialog');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signin Success'),
        ),
      );
      _socialResponseData();
      Navigator.of(context, rootNavigator: true).pop('dialog');
      // Navigator.of(context).pushReplacement(
      //   CupertinoPageRoute(
      //     builder: (context) => Home(),
      //   ),
      // );
    }
  }

  _login() async {
    CustomProgressDialogue.progressDialogue(context);
    //progressDialogue(context);
    var data = {
      'user_name': _email.text,
      'password': _password.text,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res, body;
    try {
      res = await CallApi().postData(data, 'login');
      // var resEmail = await CallApi().postData(dataEmail, 'resendCode');

      body = jsonDecode(res.body);
    } on Exception catch (_, e) {
      print("checkNet " + e.toString());
      CustomProgressDialogue.showAlertDialog(
          context, "Internet Connection", "You have no internet Connection");
      // Navigator.of(context, rootNavigator: true).pop('dialog');
    }

    //var bodyEmail = jsonDecode(resEmail.body);

    print("data: " + body.toString());
    // print("dataEmail: " + bodyEmail.toString());
    if (body == null) {
      print("In null " + body['message'].toString());
    } else if (body['success'] == false) {
      print(body['message'].toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          body['message'].toString(),
          style: TextStyle(fontSize: 16),
        ),
      ));
      Navigator.of(context, rootNavigator: true).pop('dialog');
    } else {
      print("congratulations");
      token = body['data']['token'].toString();
      u_id = body['data']['id'].toString();
      userName = body['data']['user_name'].toString();
      print("USEr Name:" + userName);
      prefs.setString("session_token", token);
      prefs.setString("user_name", userName);
      prefs.setString("user_id", u_id);
      var sToken = prefs.getString("session_token");
      var sName = prefs.getString("user_name");
      print("userID: " + prefs.getString("user_id").toString());
      print("name in login: " + sName.toString());
      print("TokenValue: " + sToken.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          body['Login Successfull'].toString(),
          style: TextStyle(fontSize: 16),
        ),
      ));
      Navigator.of(context, rootNavigator: true).pop('dialog');

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Home(sToken, sName)));
    }
  }

  // progressDialogue(BuildContext context) {
  //   //set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,
  //     content: Container(
  //       child: Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //     ),
  //   );
  //   showDialog(
  //     //prevent outside touch
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       //prevent Back button press
  //       return alert;
  //     },
  //   );
  // }

  CustomColors customColors = CustomColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // height: 50,
              //let's create a common header widget
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.only(top: 20),
              child: Image(
                image: AssetImage("assets/imgs/c512.png"),
                height: 150,
                width: 150,
              ),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                // margin: EdgeInsets.fromLTRB(
                //     20, 10, 20, 10), // This will be the login form
                child: Column(
                  children: [
                    Text(
                      'LOG-IN',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'Signin into your account',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "User Name:",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: TextFormField(
                              controller: _email,
                              decoration: ThemeHelper().textInputDecoration(
                                // 'Email Address',
                                'Enter user name',
                                Icon(Icons.email_outlined),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                email = val;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Password:",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: TextFormField(
                              controller: _password,
                              obscureText: !_obscureText,
                              decoration: ThemeHelper().textInputDecoration(
                                //'Password',
                                'Enter your password',
                                Icon(Icons.lock_outline),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(_obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter some text';
                                } else if (value.length < 6) {
                                  return 'Password be atleast 6 characters long';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                password = val;
                              },
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()),
                                );
                              },
                              child: Text(
                                "Forgot your password?",
                                style: TextStyle(
                                  color: customColors.yellowhigh,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            //child: Text('Don\'t have an account? Create'),
                            alignment: Alignment.topRight,
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: "Register yourself by clicking  ",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Here',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationPage()));
                                  },
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: customColors.yellowhigh),
                              ),
                            ])),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            color: customColors.yellowhigh,
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: customColors.background),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  _login();
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            width: double.infinity,
                            // color: Colors.transparent,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors
                                    .white, // specify the color of the border
                                width: 3.0, // specify the width of the border
                              ),
                            ),
                            child: ElevatedButton.icon(
                              style: ThemeHelper().buttonStyle(),
                              label: Text(
                                'Sign-In with Google ',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                // if (_formKey.currentState!.validate()) {
                                //   _formKey.currentState!.save();

                                // }
                                googlesignIn();
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.google,
                                size: 35,
                                // color: customColors.yellowhigh,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            // color: Colors.transparent,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors
                                    .white, // specify the color of the border
                                width: 3.0, // specify the width of the border
                              ),
                            ),
                            child: ElevatedButton.icon(
                              style: ThemeHelper().buttonStyle(),
                              label: Text(
                                'Sign-In with Facebook ',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                // if (_formKey.currentState!.validate()) {
                                //   _formKey.currentState!.save();

                                //   // _loginApp();
                                // }
                                // Navigator.of(context).pushReplacement(
                                //   MaterialPageRoute(
                                //     builder: (context) => Home(),
                                //   ),
                                // );
                                // FbSignin().login();
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.facebook,
                                size: 35,
                                //  color: customColors.yellowhigh,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            //child: Text('Don\'t have an account? Create'),

                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: "Don't you have an account? ",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Signup',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationPage()));
                                  },
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: customColors.yellowhigh),
                              ),
                            ])),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
