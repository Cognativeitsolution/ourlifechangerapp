// ignore_for_file: unnecessary_const, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:lifechangerapp/colors/colors.dart';
import 'package:lifechangerapp/common/custom_dialogue.dart';
import 'package:lifechangerapp/payments/jazz_cash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/withdraw_form_model.dart';
import '../home_pages/home.dart';
import '../payments/jazz_cash_deposit.dart';
import '../payments/permone.dart';

class WithDraw extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WithDrawState();
  }
}

class WithDrawState extends State<WithDraw> {
  WithDrawState() {
    _getToken();
  }
  var token, uid;
  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('session_token');
    uid = prefs.getString("user_id");
  }

  // Api Post Get
// Post Withdraw Request
  Future<Withdraw> createWithdraw(
    final String accountname,
    final String accountnumber,
    final String withdrawamount,
    final String paymentgatway,

    // final String username,
    // final String password,
  ) async {
    CustomProgressDialogue.progressDialogue(context);
    final ipv4 = await Ipify.ipv4();
    final http.Response response = await http.post(
      Uri.parse('https://backend.ourlifechanger.com/public/api/transactions'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer  $token',
      },
      body: jsonEncode(<String, String>{
        'account_name': accountname,
        'account_number': accountnumber,
        'debit': withdrawamount,
        'gateway_type': paymentgatway,
        'description': "Some description here",
        'user_id': uid,
        'ip_address': ipv4,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      print("Response withdraw:" + json.decode(response.body).toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Withdrawl Successfull'),
        ),
      );
      return Withdraw.fromJson(json.decode(response.body));
    } else {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Withdrawl Error'),
        ),
      );
      print("Exception");
      throw Exception("Exception Error");
    }
  }

  List<DropdownMenuItem<String>> get dropdownItemsFrom {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text(
            "Jazz Cash",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          value: "jazzcash"),
      DropdownMenuItem(
          child: Text(
            "Easy Paisa",
            style: TextStyle(color: Colors.white),
          ),
          value: "easypaisa"),
      DropdownMenuItem(
          child: Text(
            "Perfect Money",
            style: TextStyle(color: Colors.white),
          ),
          value: "perfectmoney"),
      DropdownMenuItem(
          child: Text(
            "Pay Pal",
            style: TextStyle(color: Colors.white),
          ),
          value: "pay pal"),
    ];
    return menuItems;
  }

  var amountController = TextEditingController();
  var accountNameController = TextEditingController();
  var accountNumberController = TextEditingController();

  static String selectedValue = "jazzcash";
  CustomColors _customColors = CustomColors();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: _customColors.background,
      appBar: AppBar(
        title: Text("Withdraw Balance"),
        backgroundColor: _customColors.purpleDark,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      // drawer: NavigationDrawer(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            color: _customColors.background,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  color: _customColors.purpleDark,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Withdraw Balance",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Cash out balance to your Pocket using our supported gateways.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 30),
                  color: _customColors.purpleDark,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "payment Gateway",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: _customColors.purpleLight,
                        ),
                        child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              // labelText: "Choose Payment Method",
                              // labelStyle: TextStyle(color: Colors.white),
                              fillColor: _customColors.purpleLight,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) =>
                                value == null ? "Select Payment Method" : null,
                            value: selectedValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValue = newValue!;
                              });
                            },
                            items: dropdownItemsFrom),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Your Account Name",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: accountNameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            // labelText: 'Amount',
                            // labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Enter Account Name',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.visiblePassword,
                        validator: ((value) {
                          if (value!.isEmpty)
                            return "Please enter account name";
                        }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Your Account Number",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: accountNumberController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            // labelText: 'Amount',
                            // labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Enter Account number',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.visiblePassword,
                        validator: ((value) {
                          if (value!.isEmpty)
                            return "Please enter account number";
                        }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Amount",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: amountController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            // labelText: 'Amount',
                            // labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Enter amount to deposit',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: ((value) {
                          if (value!.isEmpty) return "Please enter some amount";
                        }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    _customColors.purpleLight),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(15)),
                              ),
                              onPressed: (() {
                                Navigator.of(context).pop();
                              }),
                              child: Text(
                                "Cancel Withdraw",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    _customColors.yellowhigh),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(15)),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  setState(() {
                                    if (selectedValue == "jazzcash") {
                                      print("JAZZZZ");
                                      //_showAlertDialog();
                                      createWithdraw(
                                          accountNameController.text,
                                          accountNumberController.text,
                                          amountController.text,
                                          "jazzcash");
                                    } else if (selectedValue == "pay_pal") {
                                      print("paypalll");
                                      createWithdraw(
                                          accountNameController.text,
                                          accountNumberController.text,
                                          amountController.text,
                                          "paypal");
                                    } else if (selectedValue ==
                                        "perfectmoney") {
                                      print("Perfect money called");
                                      print("Amount: " + amountController.text);
                                      createWithdraw(
                                          accountNameController.text,
                                          accountNumberController.text,
                                          amountController.text,
                                          "perfectmoney");
                                      // double.parse(amountController.text)
                                    } else if (selectedValue == "easypaisa") {
                                      createWithdraw(
                                          accountNameController.text,
                                          accountNumberController.text,
                                          amountController.text,
                                          "easypaisa");
                                    }
                                  });
                                }
                              },
                              child: Text(
                                "Withdraw Now",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // Container(
                //   padding: EdgeInsets.fromLTRB(10, 20, 10, 30),
                //   color: _customColors.purpleDark,
                //   child: Column(
                //     children: [

                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  payPalPayment() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            clientId:
                "ATqaxgCGnk1Hd4ZrAkKTLB4p8AL6NsmB5cZ1xLJs_4ewsTimON0cBH6VdNAkvFok1nmFw8VzwdV3c3ob",
            secretKey:
                "EKCRUFRe2a9-GHWrgEGIwUgwzv1tMdk_mshDV1J3CDgfQkWiiTkBNqWJp4qQk_hiyyFNUENiGnb1qnGP",
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: const [
              {
                "amount": {
                  "total": '10.12',
                  "currency": "USD",
                  "details": {
                    "subtotal": '10.12',
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": "The payment transaction description.",
                // "payment_options": {
                //   "allowed_payment_method":
                //       "INSTANT_FUNDING_SOURCE"
                // },
                "item_list": {
                  "items": [
                    {
                      "name": "A demo product",
                      "quantity": 1,
                      "price": '10.12',
                      "currency": "USD"
                    }
                  ],

                  // shipping address is not required though
                  "shipping_address": {
                    "recipient_name": "Jane Foster",
                    "line1": "Travis County",
                    "line2": "",
                    "city": "Austin",
                    "country_code": "US",
                    "postal_code": "73301",
                    "phone": "+00000000",
                    "state": "Texas"
                  },
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              print("onSuccess: $params");
            },
            onError: (error) {
              print("onError: $error");
            },
            onCancel: (params) {
              print('cancelled: $params');
            }),
      ),
    );
  }
}
