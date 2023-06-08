// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:http/http.dart' as http;
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifechangerapp/colors/colors.dart';
import 'package:lifechangerapp/common/custom_dialogue.dart';
import 'package:lifechangerapp/home_pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/webapi.dart';
import '../common/common_info.dart';
import 'chat.dart';

class DashBoard extends StatefulWidget {
  DashBoard() {}
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DashBoardState();
  }
}

class DashBoardState extends State<DashBoard> {
  CustomColors? _customColors;
  DashBoardState() {
    _customColors = CustomColors();
   
    _getDashboard();
  }
  dynamic account, dash = [];

  CallApi _api = CallApi();
  var token, userName, accountBal, refBal, withBal, totaBal;

  Future<void> _getDashboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    await _api.fetchDashboard("dashboard_balance", token);
    var res = await _api.response;
    setState(() {
      accountBal = res['deposit'];
      refBal = res['referral'];
      withBal = res['withdraw'];
      totaBal = res['total_balance'];
    });

    print("Res dash: " + accountBal.toString());
  }

  Future<List<dynamic>> _getObjectives() async {
    //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    // userName = prefs.getString("user_name");
    await _api.fetchInfo("user-activities", token);
    // print("Resssss: " + _api.response.toString());

    account = await _api.response;
    //print("AccountLst: " + account.toString());
    return account;
  }

  @override
  Widget build(BuildContext context) {
    // _getDashboard();
   
    // TODO: implement build
    return Scaffold(
      backgroundColor: customColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: customColors.purpleLight,
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Dashboard",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    tileColor: customColors.purpleDark,
                    title: Text(
                      accountBal.toString(),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    // Center(child: CircularProgressIndicator(),) ,
                    subtitle: Text(
                      "Account Balance",
                      style: TextStyle(color: Mycolors.yellow),
                    ),
                    trailing: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    tileColor: customColors.purpleDark,
                    title: Text(
                      refBal.toString().isEmpty
                          ? "Referral Balance"
                          : refBal.toString(),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    subtitle: Text(
                      "Referral Balance",
                      style: TextStyle(color: Mycolors.yellow),
                    ),
                    trailing:
                        Icon(Icons.account_tree_outlined, color: Colors.white),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    tileColor: customColors.purpleDark,
                    title: Text(
                      withBal.toString().isEmpty
                          ? "Deposit Balance"
                          : withBal.toString(),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    subtitle: Text(
                      "Deposit Balance",
                      style: TextStyle(color: Mycolors.yellow),
                    ),
                    trailing: Icon(Icons.auto_graph, color: Colors.white),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    tileColor: customColors.purpleDark,
                    title: Text(
                      totaBal.toString().isEmpty
                          ? "TotalBalance"
                          : totaBal.toString(),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    subtitle: Text(
                      "Total Balance",
                      style: TextStyle(color: Mycolors.yellow),
                    ),
                    trailing: Icon(Icons.info_outline, color: Colors.white),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    color: customColors.purpleDark,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Account Activity",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    child: SingleChildScrollView(
                      child: FutureBuilder<List<dynamic>>(
                        future: _getObjectives(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            print("true");
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                border: TableBorder.all(
                                    width: 1, color: customColors.background),
                                headingRowColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => customColors.purpleLight),
                                dataRowColor: MaterialStateProperty.resolveWith(
                                    (states) => customColors.purpleDark),
                                headingTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                dataTextStyle: TextStyle(color: Colors.white),
                                columnSpacing: 30,
                                columns: const [
                                  DataColumn(label: Text('IP')),
                                  DataColumn(label: Text('OS')),
                                  DataColumn(label: Text('Device')),
                                  DataColumn(label: Text('Browser')),
                                  DataColumn(label: Text('Time')),
                                ],
                                rows: List.generate(
                                  snapshot.data!.length,
                                  (index) {
                                    var data = snapshot.data![index];
                                    //  print("inside snapshot: " + data);
                                    return DataRow(cells: [
                                      DataCell(
                                        Text(account[index]['user_ip']
                                            .toString()),
                                      ),
                                      DataCell(
                                        Text(account[index]['user_os']
                                            .toString()),
                                      ),
                                      DataCell(
                                        Text(account[index]['user_device']
                                            .toString()),
                                      ),
                                      DataCell(
                                        Text(account[index]['user_browser']
                                            .toString()),
                                      ),
                                      DataCell(
                                        Text(account[index]['time'].toString()),
                                      ),
                                    ]);
                                  },
                                ).toList(),
                                showBottomBorder: true,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          // By default show a loading spinner.
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ChatApp()));
                      },
                      child: Icon(Icons.chat_bubble),
                      backgroundColor: _customColors!.yellowhigh,
                      foregroundColor: _customColors!.background,
                      tooltip: "Chat with us",
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
