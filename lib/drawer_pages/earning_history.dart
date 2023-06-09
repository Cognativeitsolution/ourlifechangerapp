// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifechangerapp/home_pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/earning_history_model.dart';
import '../colors/colors.dart';
import '../common/custom_text.dart';

class EarningHistory extends StatefulWidget {
  const EarningHistory({super.key});

  @override
  State<EarningHistory> createState() => _EarningHistoryState();
}

var token;

class _EarningHistoryState extends State<EarningHistory> {
  final String apiUrl =
      "https://backend.ourlifechanger.com/public/api/earning_history";

  Future<List<EarningHi>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer  $token',
      },
    );
    return (json.decode(response.body)['data'] as List)
        .map((e) => EarningHi.fromJson(e))
        .toList();
  }

  var statusText;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.darkPurple,
        appBar: AppBar(
          title: Text("Earning History"),
          backgroundColor: customColors.purpleDark,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //const CustomText(text: "", fontSize: 22),
                // const SizedBox(height: 10),
                FutureBuilder<List<EarningHi>>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<EarningHi> data = snapshot.data as List<EarningHi>;
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            // setState(() {
                            //   if (data[index].status == 1) {
                            //     statusText = "Complete";
                            //   } else {
                            //     statusText = "Pending";
                            //   }
                            // });
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Card(
                                  color: Mycolors.lightPurple,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //First Row
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          //color: Mycolors.yellow,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Mycolors.yellow),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText(
                                                text:
                                                    "Gateway: ${data[index].gateway}"
                                                        .toUpperCase(),
                                                textColor: Mycolors.darkPurple,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: CustomText(
                                              text:
                                                  "Earning Source:  ${data[index].earningsource}"),
                                        ),

                                        SizedBox(
                                          height: 5,
                                        ),
                                        //Second Row
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: CustomText(
                                              text:
                                                  "Transation ID:  ${data[index].transid}"),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: CustomText(
                                              text:
                                                  "Credit Amount:  ${data[index].credit}"),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: CustomText(
                                              text: data[index].status == 1
                                                  ? "Status:  " + "Complete"
                                                  : "Status: " + "Pending"),
                                        ), //Third Row
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: CustomText(
                                            text: "Date:  " +
                                                DateFormat('d MMM yyyy hh:mm a')
                                                    .format(DateTime.parse(
                                                        data[index].date)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                    if (snapshot.hasError) {
                      return const CustomText(
                        text: "No Data avaliable",
                      );
                    }
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Mycolors.yellow,
                    ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
