import 'package:flutter/material.dart';
import 'package:lifechangerapp/api/webapi.dart';
import 'package:lifechangerapp/common/custom_dialogue.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/notificiations_model.dart';
import '../colors/colors.dart';
import '../common/custom_text.dart';

class AllNotification extends StatefulWidget {
  const AllNotification({super.key});

  @override
  State<AllNotification> createState() => _AllNotificationState();
}

class _AllNotificationState extends State<AllNotification> {
  dynamic refList = [];
  var token;
  CallApi _api = CallApi();
  final String apiUrl =
      "https://backend.ourlifechanger.com/public/api/watch-announcements";
  Future<List<Noti>> fetchData() async {
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
    print(json.decode(response.body)['data']['total_announcements']);
    return (json.decode(response.body)['data']['total_announcements'] as List)
        .map((e) => Noti.fromJson(e))
        .toList();
  }

  CustomColors customColors = CustomColors();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: customColors.background,
        appBar: AppBar(
          title: Text("Notifications"),
          backgroundColor: customColors.purpleDark,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: notification(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget notification() {
    return FutureBuilder<List<Noti>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Noti> data = snapshot.data as List<Noti>;
            // print("data print: "+data.toString());
            return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.5),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Mycolors.purple,
                    ),
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              CustomProgressDialogue.showAlertDialog(
                                  context,
                                  data[index].title.toString(),
                                  data[index].description.toString());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: CustomText(
                                    text: "${data[index].title}",
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis,
                                    textColor: customColors.yellowhigh,
                                  ),
                                ),
                                Expanded(
                                  child: Lottie.asset(
                                      "assets/lottie/notification.json",
                                      height: 60,
                                      fit: BoxFit.fill),
                                ),
                              ],
                            ),
                          ),
                          CustomText(
                            overflow: TextOverflow.ellipsis,
                            text: "${data[index].description}",
                            maxline: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                );
                // ListTile(
                //   tileColor: Mycolors.lightPurple,
                //   leading: const Icon(Icons.list),
                //   trailing: const Text(
                //     "GFG",
                //     style: TextStyle(color: Colors.green, fontSize: 15),
                //   ),
                //   title: Text("List item $index"),
                // );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
