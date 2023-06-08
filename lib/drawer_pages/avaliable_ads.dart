import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lifechangerapp/drawer_pages/youtubeplayer.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/user_video_model.dart';
import '../colors/colors.dart';
import '../common/custom_button.dart';
import '../common/custom_text.dart';

class AvaliableAds extends StatefulWidget {
  const AvaliableAds({super.key});

  @override
  State<AvaliableAds> createState() => _AvaliableAdsState();
}

class _AvaliableAdsState extends State<AvaliableAds> {
  String value = "0";
  var token;

  final String apiUrl =
      "https://backend.ourlifechanger.com/public/api/get_user_videos";

  Future<List<UserVideos>> fetchData() async {
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
    return (json.decode(response.body)['data']['all_videos'] as List)
        .map((e) => UserVideos.fromJson(e))
        .toList();
  }

  CustomColors _colors = CustomColors();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.darkPurple,
        appBar: AppBar(
          title: const Text("View Cash Videos"),
          backgroundColor: _colors.purpleDark,
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
                  text: "Avaliable Ads",
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                cardAdsDetail(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Details in Card
  Widget cardAdsDetail(BuildContext context) {
    return FutureBuilder<List<UserVideos>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<UserVideos> data = snapshot.data as List<UserVideos>;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  height: 350,
                  width: double.infinity,
                  child: Card(
                    color: Mycolors.lightPurple,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/imgs/film_icon.png",
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          CustomText(
                            text: data[index].name,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: DateFormat('d MMM yyyy hh:mm a')
                                .format(DateTime.parse(data[index].date)),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 43,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Mycolors.yellow),
                                  child: Center(
                                      child: CustomText(
                                    text: data[index].status == value
                                        ? "Not View"
                                        : "Complete",
                                    textColor: Colors.black,
                                  )),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: CustomButton(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  YoutubePlayerScreen(
                                                      detail: data[index])),
                                        );
                                      },
                                      buttonText: "View Ads",
                                      sizeWidth: double.infinity))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        if (snapshot.hasError) {
          return const CustomText(
            text: "Fail To Get Data",
          );
        }
        return const Center(
            child: CircularProgressIndicator(
          color: Mycolors.yellow,
        ));
      },
    );
  }
}

// Sucess Dialog
Future dialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Mycolors.darkPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Lottie.asset("assets/lottie/doneanimation.json",
            height: 150, repeat: false),
        title: const CustomText(text: "Earn Successful"),
        content:
            const CustomText(text: "The Video Ads Has Been successfully Viewd"),
        actions: [
          CustomButton(
            onTap: () {
              Navigator.pop(context);
            },
            buttonText: "OK",
            sizeWidth: 100,
          ),
        ],
      );
    },
  );
}
