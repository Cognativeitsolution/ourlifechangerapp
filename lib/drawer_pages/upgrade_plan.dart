import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifechangerapp/api/webapi.dart';
import 'package:lifechangerapp/common/custom_button.dart';
import 'package:lifechangerapp/common/custom_dialogue.dart';
import 'package:lifechangerapp/home_pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors/colors.dart';
import '../common/custom_text.dart';
import '../common/packages.dart';

class AllPackegs extends StatefulWidget {
  const AllPackegs({super.key});

  @override
  State<AllPackegs> createState() => _AllPackegsState();
}

final startdate = DateFormat('d/M/yyyy').format(DateTime.now());
const String apiUrl =
    "https://backend.ourlifechanger.com/public/api/packages_list";

class _AllPackegsState extends State<AllPackegs> {
  var token;
  var uid;
  _AllPackegsState() {
    // _getPrefData();
  }
  _getPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    print("token pckg:" + token);
    uid = prefs.getString("user_id");
    print("id pckg:" + uid);
  }

  Future<List<AllPackage>> fetchPackegList() async {
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
    _parentsData();
    // print(json.decode(response.body)['data']['packages'][0]['id']);
    return (json.decode(response.body)['data']['packages'] as List)
        .map((e) => AllPackage.fromJson(e))
        .toList();
  }

  CallApi _api = CallApi();
  var fParentid, sParentid;
  var package_id;

  _parentsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    uid = prefs.getString("user_id");
    print("userid" + uid);
    CallApi _api = CallApi();
    var data = {
      'id': 26,
    };
    var result = await _api.postInfoData(data, 'get_parent', token);
    var body = jsonDecode(result.body);
    fParentid = body['data']['first_parent']['id'];
    sParentid = body['data']['second_parent']['id'];
    print(
        "parents: " + fParentid.toString() + "second: " + sParentid.toString());
  }

  var msg;
  _postPurchaseData() async {
    print("parents: " + fParentid.toString() + sParentid.toString());
    CustomProgressDialogue.progressDialogue(context);
    //_parentsData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    uid = prefs.getString("user_id");
    print("userid" + uid);
    print("pkgid:: " + package_id.toString());
    var data = {
      'package_id': package_id,
      'first_parent_id': fParentid,
      'second_parent_id': sParentid,
    };
    var result = await _api.postInfoData(data, 'purchase-package', token);
    var body = jsonDecode(result.body);
    print("postPaackage: " + body.toString());
    print("msg" + body['message'].toString());
    msg = body['message'].toString();
    if (body['success'] == true) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg.toString()),
        ),
      );
      print("postPaackage: " + body.toString());
    } else {
      print("Code:" + result.statusCode.toString());
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg.toString()),
        ),
      );
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.darkPurple,
        appBar: AppBar(
          title: Text("Upgrade Plan"),
          backgroundColor: customColors.purpleDark,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'All Packages',
                  fontSize: 22,
                ),
                packagesCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget packagesCard() {
    return FutureBuilder<List<AllPackage>>(
        future: fetchPackegList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<AllPackage> data = snapshot.data as List<AllPackage>;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: SizedBox(
                      height: 320,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "${data[index].name}",
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                textColor: Mycolors.yellow,
                              ),
                              const SizedBox(
                                height: 5,
                              ),

                              //Decprition and Image
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                        text: "${data[index].description}",
                                        maxline: 4,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Expanded(
                                      child: Image.network(
                                    "https://backend.ourlifechanger.com/public/images/${data[index].image}",
                                    height: 100,
                                  )),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              //Price and ads limit
                              Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                    color: Mycolors.darkPurple),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomText(
                                        text:
                                            "Ads Limit:  ${data[index].limit}"),
                                    CustomText(text: "Rs: ${data[index].price}")
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              //Duration
                              Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                    color: Mycolors.darkPurple),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomText(text: "start: " + startdate),
                                    CustomText(
                                        text: "End: " +
                                            DateFormat('d/M/yyyy').format(
                                                DateTime.now().add(Duration(
                                                    days:
                                                        data[index].duration))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomButton(
                                onTap: () {
                                  print("id: " + data[index].id.toString());
                                  package_id = data[index].id;
                                  _postPurchaseData();
                                },
                                buttonText: 'Get Started',
                                sizeWidth: double.infinity,
                                buttonColor: Mycolors.yellow,
                                textColor: Mycolors.darkPurple,
                                boderRadius: 20,
                                fontWeight: FontWeight.bold,
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
              text: "Fail To Get Data",
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Mycolors.yellow,
            ),
          );
        });
  }
}
