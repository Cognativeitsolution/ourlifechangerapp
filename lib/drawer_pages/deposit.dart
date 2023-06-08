// ignore_for_file: unnecessary_const, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:lifechangerapp/colors/colors.dart';
import 'package:lifechangerapp/common/custom_dialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/deposit_amount.dart';
import '../payments/jazz_cash_deposit.dart';
import '../payments/permone.dart';

class DepositBalance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DepositBalanceState();
  }
}

var token, uid;

class DepositBalanceState extends State<DepositBalance> {
  DepositBalanceState() {
    _getToken();
  }
  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('session_token');
    uid = prefs.getString("user_id");
  }

  List<DropdownMenuItem<String>> get dropdownItems {
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
            "EasyPesa",
            style: TextStyle(color: Colors.white),
          ),
          value: "easypaisa"),
      DropdownMenuItem(
          child: Text(
            "PayPal",
            style: TextStyle(color: Colors.white),
          ),
          value: "pay_pal"),
      DropdownMenuItem(
          child: Text(
            "Perfect Money",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          value: "perfectmoney"),
    ];
    return menuItems;
  }

  var amountController = TextEditingController();
  var tidController = TextEditingController();
  static String selectedValue = "jazzcash";
  CustomColors _customColors = CustomColors();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: _customColors.background,
      appBar: AppBar(
        title: Text("Deposit Balance"),
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
                          "Deposit Balance",
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
                        "Cash in balance to your account using instant deposit and local deposit",
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
                          "Ad Funds",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Read before deposit your balance. You need to know gateway fee:",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: _customColors.purpleLight,
                        ),
                        child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "Choose Payment Method",
                              labelStyle: TextStyle(color: Colors.white),
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
                            items: dropdownItems),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: amountController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelText: 'Amount',
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Enter amount to deposit',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: ((value) {
                          if (value!.isEmpty) return "Please enter some amount";
                        }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: tidController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelText: 'Transaction ID',
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'JazzCash/Easypesa transaction id',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: ((value) {
                          if (value!.isEmpty) return "Please enter some value";
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
                                "Cancel Desposit",
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
                                      depositamount(amountController.text,
                                          "jazzcash", tidController.text);
                                    } else if (selectedValue == "pay_pal") {
                                      print("paypalll");
                                      payPalPayment();
                                    } else if (selectedValue ==
                                        "perfectmoney") {
                                      print("Perfect money called");
                                      print("Amount: " + amountController.text);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Permoney(
                                                    amount: double.parse(
                                                        amountController.text),
                                                  )));
                                      // double.parse(amountController.text)
                                    } else if (selectedValue == "easypaisa") {
                                      depositamount(amountController.text,
                                          "easypaisa", tidController.text);
                                    }
                                  });
                                }
                              },
                              child: Text(
                                "Desposit Now",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Despositamount> depositamount(
    final String deposit,
    // final String paymentgatway,
    // final String description,
    final String gateway,
    final String tid,
//    final String status,
  ) async {
    CustomProgressDialogue.progressDialogue(context);
    final ipv4 = await Ipify.ipv4();

    print("amout: " + deposit);
    print("tid: " + tid);
    print("gate: " + gateway);
    print("user: " + uid);
    print("tokken: " + token);
    print("ip: " + ipv4);

    final http.Response response = await http.post(
      Uri.parse('https://backend.ourlifechanger.com/public/api/transactions'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer  $token',
      },
      body: jsonEncode(<String, String>{
        'deposit': deposit,
        'tid': tid,
        'gateway_type': gateway,
        'description': 'demo',
        'user_id': uid,
        'ip_address': ipv4,
        'status': '0',
      }),
    );
    print("Deposit cash response: " + json.decode(response.body).toString());
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment Successful'),
        ),
      );
      Navigator.of(context, rootNavigator: true).pop('dialog');
      print("Deposit cash response: " + json.decode(response.body).toString());
      return Despositamount.fromJson(json.decode(response.body));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment Failed'),
        ),
      );
      Navigator.of(context, rootNavigator: true).pop('dialog');
      throw Exception("Exception Error");
    }
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
            transactions: [
              {
                "amount": {
                  "total": amountController.text,
                  "currency": "USD",
                  "details": {
                    "subtotal": amountController.text,
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
                      "price": amountController.text,
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
