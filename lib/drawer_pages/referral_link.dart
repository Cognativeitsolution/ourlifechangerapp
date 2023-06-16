// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/webapi.dart';
import '../colors/colors.dart';
import '../common/custom_text.dart';

class Referral extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReferralState();
  }
}

class ReferralState extends State<Referral> {
  ReferralState() {
    getRefLink();
  }
  final _referralLink = TextEditingController();

  // This function is triggered when the copy icon is pressed
  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: refLink));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  dynamic refList = [];
  dynamic childList = [];

  share() {
    Share.share(refLink, subject: "Our Life changer App");
  }

  var userName;
  getRefLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("user_name");
    print("Username in reflink: " + userName.toString());
    refLink =
        "https://ourlifechanger.com/test/#/register/" + userName.toString();
    print("RefLink: " + refLink);
    _referralLink.text = refLink;
  }

  CallApi _api = CallApi();
  var token;
  var myStat;
  var refLink;

  Future<List<dynamic>> _getObjectives() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //token = "602|CzOAqewpH0zVl6AIhXvjfCjCKpOicsNLbXQK0MKm";
    token = prefs.getString("session_token");
    await _api.fetchObjectives("referrals", token);
    print("Resssss: " + _api.response[0]['childs'].toString());
    refList = await _api.response[0]['childs'];
    print("RefList: " + refList.toString());

    //  int  child_count=refList['childs_count'];
    //   print("Count: "+child_count.toString());

    //int count = 0;

    // print("ChildList: " + childList.toString());
    return refList;
  }

  CustomColors _colors = CustomColors();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Mycolors.darkPurple,
      appBar: AppBar(
        title: Text("My Referrals"),
        backgroundColor: _colors.purpleDark,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "My Referral Link",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _referralLink,
                readOnly: true,
                style: TextStyle(color: Colors.yellowAccent),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  //labelText: refLink,
                  // labelStyle: TextStyle(color: Colors.yellowAccent),
                  icon: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.share),
                    onPressed: () {
                      // print("shared");
                      share();
                    },
                  ),
                  suffixIcon: IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.copy),
                    onPressed: _copyToClipboard,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "My Referrals",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: FutureBuilder<List<dynamic>>(
                    future: _getObjectives(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List data = snapshot.data as List;
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                height: 220,
                                width: double.infinity,
                                child: Card(
                                  color: Mycolors.lightPurple,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Name and PAckege name
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              text: refList[index]['name']
                                                  .toString(),
                                              fontWeight: FontWeight.bold,
                                            ),
                                            CustomText(
                                              text: refList[index]
                                                      ['package_name']
                                                  .toString(),
                                              fontWeight: FontWeight.bold,
                                              textColor: Mycolors.yellow,
                                              fontSize: 18,
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          height: 3,
                                          color: Mycolors.yellow,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),

                                        // Total Earning and Today Earning
                                        Container(
                                          height: 60,
                                          color: Mycolors.darkPurple,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomText(
                                                        text: "Totol Earn"),
                                                    CustomText(
                                                      text:
                                                          "Rs ${refList[index]['total_earn']}"
                                                              .toString(),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: VerticalDivider(
                                                  color: Mycolors.yellow,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomText(
                                                        text: "Today Earn"),
                                                    CustomText(
                                                      text:
                                                          "Rs ${refList[index]['today_earn']}"
                                                              .toString(),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),

                                        //status and country
                                        Container(
                                          height: 35,
                                          color: Mycolors.darkPurple,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                    child: CustomText(
                                                      text: refList[index]
                                                                  ['status'] ==
                                                              1
                                                          ? myStat = "Active"
                                                          : myStat = "InActive"
                                                              .toString(),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: VerticalDivider(
                                                    color: Mycolors.yellow,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: CustomText(
                                                      text: refList[index]
                                                              ['contact']
                                                          .toString(),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),

                                        //Start and End Date
                                        Container(
                                          height: 35,
                                          color: Mycolors.darkPurple,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                    child: CustomText(
                                                      text: refList[index]
                                                              ['start_date']
                                                          .toString(),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: VerticalDivider(
                                                    color: Mycolors.yellow,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: CustomText(
                                                      text: refList[index]
                                                              ['end_date']
                                                          .toString(),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _showAlertDialog(dynamic list, int index) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         // <-- SEE HERE
  //         title: const Text('Referral Details'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text("Joining date: " + list[index]['jdate']),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Text("Package: " + list[index]['pkg']),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Text("Start Date: " + "abc date"),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Text("End Date: " + "abc date"),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
