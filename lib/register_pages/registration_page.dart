// ignore_for_file: unnecessary_new, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names, prefer_interpolation_to_compose_strings, unused_local_variable, unnecessary_import, prefer_is_not_empty

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lifechangerapp/common/custom_dialogue.dart';
import 'package:lifechangerapp/register_pages/login_page.dart';
import 'package:lifechangerapp/register_pages/verification_page.dart';

import '../api/webapi.dart';
import '../colors/colors.dart';
import '../custom_widget/header_widget.dart';
import '../helper/theme_helper.dart';
import '../home_pages/home.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  bool _obscureText = false;
  bool _obscureConfirmPass = false;

  String? email;
  String? password;
  String? confirm_password;
  String? name;
  String? contact;

  final _email = TextEditingController();
  final _name = TextEditingController();
  final _userName = TextEditingController();
  final _referredBy = TextEditingController();
  final _password = TextEditingController();
  final _confirm_password = TextEditingController();
  final _contact = TextEditingController();

  CustomColors customColors = CustomColors();

  _register() async {
    var data = {
      'name': _name.text,
      'email': _email.text,
      'user-name': _userName.text,
      'password': _password.text,
      'c_password': _confirm_password.text,
      'contact': _contact.text,
      'referred_by': _referredBy.text.isEmpty ? 'Tahseen110' : _referredBy.text,
    };
    var dataEmail = {
      'email': _email.text,
    };
    CustomProgressDialogue.progressDialogue(context);
    var res = await CallApi().postData(data, 'register');
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
                builder: (context) => VerificationPage(otpMail: _email.text)));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.only(top: 20),
              child: Image(
                image: AssetImage("assets/imgs/c512.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "Registration",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextFormField(
                            controller: _name,
                            decoration: ThemeHelper().textInputDecoration(
                              // 'Your Full Name',
                              'Full Name',
                              Icon(Icons.person),
                            ),
                            maxLength: 30,
                            validator: (val) {
                              if ((val!.isEmpty)) {
                                return "Name cannot be empty";
                              } else if (!RegExp(
                                      r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
                                  .hasMatch(val)) {
                                return "Enter a valid name";
                              }
                              return null;
                            },
                            onChanged: (val) {
                              name = _name.text;
                              print("Name value: " + name.toString());
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),

                        SizedBox(height: 20.0),
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
                              if ((val!.isEmpty)) {
                                return "Email cannot be empty";
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
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
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),

                        Container(
                          child: TextFormField(
                            controller: _referredBy,
                            decoration: ThemeHelper().textInputDecoration(
                              // 'Your Full Name',
                              'Referred By (Optional)',
                              Icon(Icons.person),
                            ),
                            onChanged: (val) {
                              name = _name.text;
                              print("Name value: " + name.toString());
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: IntlPhoneField(
                            controller: _contact,
                            decoration: ThemeHelper().textInputDecoration(
                                // "Mobile Number",
                                "Contact Number",
                                Icon(Icons.mobile_friendly)),
                            keyboardType: TextInputType.phone,
                            initialCountryCode: 'PK',
                            onChanged: (val) {
                              contact = _contact.text;
                              print("Contact: " + contact.toString());
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        // SizedBox(height: 5.0),
                        Container(
                          child: TextFormField(
                            controller: _password,
                            obscureText: !_obscureText,
                            decoration: ThemeHelper().textInputDecoration(
                              // "Password*",
                              "Password",
                              Icon(Icons.lock_outline),
                              GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                }),
                                child: Icon(_obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              password = val;
                            },
                            onChanged: (val) {
                              password = _password.text;
                              print("Password: " + password.toString());
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _confirm_password,
                            obscureText: !_obscureConfirmPass,
                            decoration: ThemeHelper().textInputDecoration(
                              // "Confirm Password*",
                              "Confirm Password",
                              Icon(Icons.lock_outline),
                              GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    _obscureConfirmPass = !_obscureConfirmPass;
                                  });
                                }),
                                child: Icon(_obscureConfirmPass
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                            validator: (val) {
                              print("Value: " + val.toString());
                              print("Password: " + password.toString());
                              if (val!.isEmpty) {
                                return "Please confirm your password";
                              } else if (val != password) {
                                return "Your password doesn't match";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              confirm_password = val;
                            },
                            onChanged: (val) {
                              confirm_password = _confirm_password.toString();
                              print("Confirmed Password: " +
                                  confirm_password.toString());
                              // if (confirm_password != password) {
                              //   return "Password does not match";
                              // }
                              // return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),

                        SizedBox(height: 20.0),
                        Container(
                          color: customColors.yellowhigh,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                              child: Text(
                                'Create Account',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: customColors.background),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                _register();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Container(
                        //   width: double.infinity,
                        //   // color: Colors.transparent,
                        //   decoration: BoxDecoration(
                        //     border: Border.all(
                        //       color: Colors
                        //           .white, // specify the color of the border
                        //       width: 3.0, // specify the width of the border
                        //     ),
                        //   ),
                        //   child: ElevatedButton.icon(
                        //     style: ThemeHelper().buttonStyle(),
                        //     label: Text(
                        //       'Sign-In with Google ',
                        //       style: TextStyle(
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.white),
                        //     ),
                        //     onPressed: () {
                        //       // if (_formKey.currentState!.validate()) {
                        //       //   _formKey.currentState!.save();

                        //       //   // _loginApp();
                        //       // }
                        //       Navigator.of(context).pushReplacement(
                        //         MaterialPageRoute(
                        //           builder: (context) => Home(),
                        //         ),
                        //       );
                        //     },
                        //     icon: FaIcon(
                        //       FontAwesomeIcons.google,
                        //       size: 35,
                        //       // color: customColors.yellowhigh,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Container(
                        //   width: double.infinity,
                        //   // color: Colors.transparent,
                        //   decoration: BoxDecoration(
                        //     border: Border.all(
                        //       color: Colors
                        //           .white, // specify the color of the border
                        //       width: 3.0, // specify the width of the border
                        //     ),
                        //   ),
                        //   child: ElevatedButton.icon(
                        //     style: ThemeHelper().buttonStyle(),
                        //     label: Text(
                        //       'Sign-In with Facebook ',
                        //       style: TextStyle(
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.white),
                        //     ),
                        //     onPressed: () {
                        //       // if (_formKey.currentState!.validate()) {
                        //       //   _formKey.currentState!.save();

                        //       //   // _loginApp();
                        //       // }
                        //       Navigator.of(context).pushReplacement(
                        //         MaterialPageRoute(
                        //           builder: (context) => Home(),
                        //         ),
                        //       );
                        //     },
                        //     icon: FaIcon(
                        //       FontAwesomeIcons.facebook,
                        //       size: 35,
                        //       //  color: customColors.yellowhigh,
                        //     ),
                        //   ),
                        // ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          //child: Text('Don\'t have an account? Create'),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(color: Colors.white)),
                            TextSpan(
                              text: 'Login',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                      (route) => false);
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
          ],
        ),
      ),
    );
  }
}
