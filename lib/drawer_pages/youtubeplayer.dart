import 'dart:convert';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../api/earning_amount_model.dart';
import '../api/user_video_model.dart';
import '../colors/colors.dart';
import '../common/custom_text.dart';
import 'avaliable_ads.dart';

class YoutubePlayerScreen extends StatefulWidget {
  const YoutubePlayerScreen({
    required this.detail,
    super.key,
  });
  final UserVideos detail;
  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;
  var token, uid;
  var amount;

  @override
  void initState() {
    var videoId = YoutubePlayer.convertUrlToId("${widget.detail.videolink}");
    _controller = YoutubePlayerController(
        initialVideoId: "$videoId",
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          isLive: true,
          disableDragSeek: true,
          hideControls: true,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Mycolors.darkPurple,
          body: SingleChildScrollView(
            child: Column(
              children: [
                YoutubePlayer(
                  onEnded: (metaData) {
                    updateVideostatus();
                    //sendEarningData();
                    // earningAmount();
                    Navigator.of(context).pop();
                    // Navigator.pushReplacement(
                    //   context,
                    //   CupertinoPageRoute(
                    //       builder: (context) => const AvaliableAds()),
                    // );
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(
                    //       builder: (context) => const AvaliableAds(),
                    //     ),
                    //     (route) => false);
                    setState(() {
                      dialog(context);
                    });
                  },
                  showVideoProgressIndicator: true,
                  controller: _controller,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: widget.detail.name,
                        fontSize: 25,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomText(
                        text: "${widget.detail.description}",
                        fontSize: 15,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // User Video status Update
  Future updateVideostatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    print("Tokeen: " + token);
    uid = prefs.getString("user_id");
    print("User id: " + uid);
    final http.Response response = await http.post(
      Uri.parse(
          'https://backend.ourlifechanger.com/public/api/update_user_videos'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer  $token',
      },
      body: jsonEncode(<String, String>{
        'user_id': uid,
        'video_id': widget.detail.id.toString(),
      }),
    );
    if (response.statusCode == 200) {
      print("Video Status: " + jsonDecode(response.body).toString());
      earningAmount();
      return jsonDecode(response.body);
    } else {
      throw Exception("Your video limit has exceeded.");
    }
  }

  // Post Ads Earning Data
  Future<Map<String, dynamic>> sendEarningData({
    //var credit = ad_amount,
    String withdraw = "0",
    String gateway = "perfectmoney",
    String earning = "ad",
  }) async {
    print("Send Earning data method called");
    final ipv4 = await Ipify.ipv4();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    uid = prefs.getString("user_id");
    final http.Response response = await http.post(
      Uri.parse('https://backend.ourlifechanger.com/public/api/transactions'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer  $token',
      },
      body: jsonEncode(<String, dynamic>{
        'description': widget.detail.name,
        'credit': ad_amount,
        'is_withdraw': withdraw,
        'gateway_type': gateway,
        'earning_source': earning,
        'user_id': uid,
        'ip_address': ipv4,
      }),
    );

    if (response.statusCode == 200) {
      print("Response video: " + jsonDecode(response.body).toString());
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print("Failed Response: " + response.body);
      throw Exception("Exception Error");
    }
  }

  var ad_amount;
  //Get Earning Amount
  Future<EarnimgAmount> earningAmount() async {
    print("Earning amount method  called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    final response = await http.get(
      Uri.parse(
          'https://backend.ourlifechanger.com/public/api/watch-ad-amount'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer  $token',
      },
    );
    print("Code: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      ad_amount = jsonDecode(response.body)['data']['watch_ad_amount'];
      sendEarningData();
      print("Ad Amountttt: " + ad_amount.toString());
      amount = EarnimgAmount.fromJson(json.decode(response.body));
      // print("Amount Response: " + amount.toString());
      return amount;
      // amount = EarnimgAmount.fromJson(json.decode(response.body));
      //return amount;
    } else {
      throw Exception('Failed to load balance');
    }
  }
}
