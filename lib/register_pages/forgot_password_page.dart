import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../api/webapi.dart';
import '../common/custom_dialogue.dart';
import '../custom_widget/header_widget.dart';
import '../helper/theme_helper.dart';
import 'otp_forgot_pass.dart';
import 'verification_page.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  _forgotPass() async {
    var dataEmail = {
      'email': _email.text,
    };
    CustomProgressDialogue.progressDialogue(context);
    var res = await CallApi().postData(dataEmail, 'forgot-password');
    // var resEmail = await CallApi().postData(dataEmail, 'resendCode');

    var body = jsonDecode(res.body);
    //var bodyEmail = jsonDecode(resEmail.body);

    print("data: " + body.toString());
    // print("dataEmail: " + bodyEmail.toString());
    if (body != null) {
      print("In null " + body['message'].toString());

      if (body['success'] != null) {
        print("congratulations");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            body['message'].toString(),
            style: TextStyle(fontSize: 16),
          ),
        ));
        Navigator.of(context, rootNavigator: true).pop('dialog');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ForgotPassVerificationPage(otpMail: _email.text)),
        );
      } else {
        print(body['message'].toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            body['message'].toString(),
            style: TextStyle(fontSize: 16),
          ),
        ));
        Navigator.of(context, rootNavigator: true).pop('dialog');
      }
    } else {
      print("go to hell");
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  String? email;

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child:
                    HeaderWidget(_headerHeight, true, Icons.password_rounded),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Enter the email address associated with your account.',
                              style: TextStyle(
                                  // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'We will email you a verification code to check your authenticity.',
                              style: TextStyle(
                                color: Colors.black38,
                                // fontSize: 20,
                              ),
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                controller: _email,
                                decoration: ThemeHelper().textInputDecoration(
                                  // "E-mail address",
                                  "Email Address",
                                  Icon(Icons.email_outlined),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (!(val!.isEmpty) &&
                                      !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                          .hasMatch(val)) {
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  email = val;
                                },
                                onChanged: (val) {
                                  email = _email.text;
                                  print("Email value: " + email.toString());
                                },
                              ),
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              decoration:
                                  ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Send".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _forgotPass();
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: "Remember your password? "),
                                  TextSpan(
                                    text: 'Login',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()),
                                        );
                                      },
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
