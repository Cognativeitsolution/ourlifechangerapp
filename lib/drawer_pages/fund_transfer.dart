// ignore_for_file: unnecessary_const, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:lifechangerapp/colors/colors.dart';
import 'package:lifechangerapp/payments/jazz_cash.dart';

import '../home_pages/home.dart';

import '../payments/jazz_cash_deposit.dart';

class FundsTransfer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FundsTransferState();
  }
}

class FundsTransferState extends State<FundsTransfer> {
  List<DropdownMenuItem<String>> get dropdownItemsFrom {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text(
            "Referral Balance",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          value: "reference_balance"),
      DropdownMenuItem(
          child: Text(
            "Earning Balance",
            style: TextStyle(color: Colors.white),
          ),
          value: "earning_balance"),
      DropdownMenuItem(
          child: Text(
            "Deposit Balance",
            style: TextStyle(color: Colors.white),
          ),
          value: "deposit_balance"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemsTo {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text(
            "Earning Balance",
            style: TextStyle(color: Colors.white),
          ),
          value: "earning_balance"),
      DropdownMenuItem(
          child: Text(
            "Deposit Balance",
            style: TextStyle(color: Colors.white),
          ),
          value: "deposit_balance"),
    ];
    return menuItems;
  }

  static String selectedToVal = "deposit_balance";
  var amountController = TextEditingController();
  static String selectedValue = "reference_balance";
  CustomColors _customColors = CustomColors();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: _customColors.background,
      appBar: AppBar(
        title: Text("Funds Transfer"),
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
                        "Funds Transfer",
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
                      "Transfer your Balance to Other Member and Account.",
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
                        "From",
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
                        "To",
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
                          value: selectedToVal,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedToVal = newValue!;
                            });
                          },
                          items: dropdownItemsTo),
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
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
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
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(15)),
                            ),
                            onPressed: null,
                            child: Text(
                              "Cancel Exchange",
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
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(15)),
                            ),
                            onPressed: () {
                              // setState(() {
                              //   if (selectedValue == "jazz_cash") {
                              //     print("JAZZZZ");
                              //     _showAlertDialog();
                              //   } else if (selectedValue == "pay_pal") {
                              //     print("paypalll");
                              //     payPalPayment();
                              //   }
                              // });
                            },
                            child: Text(
                              "Exchange Now",
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
    );
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Summary of Transaction'),
          content: JazzCashDeposit(amount: amountController.text),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
