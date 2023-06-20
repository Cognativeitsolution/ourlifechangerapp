// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings, prefer_if_null_operators

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lifechangerapp/api/webapi.dart';
import 'package:lifechangerapp/common/custom_dialogue.dart';
import 'package:lifechangerapp/drawer_pages/deposit_history.dart';
import 'package:lifechangerapp/drawer_pages/referral_link.dart';
import 'package:lifechangerapp/drawer_pages/upgrade_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/google_signin_api.dart';
import '../colors/colors.dart';
import '../common/noti_icon.dart';
import '../drawer_pages/avaliable_ads.dart';
import '../drawer_pages/dashboard.dart';
import '../drawer_pages/deposit.dart';
import '../drawer_pages/earning_history.dart';
import '../drawer_pages/fund_transfer.dart';
import '../drawer_pages/notification.dart';
import '../drawer_pages/profile.dart';
import '../drawer_pages/with_draw.dart';
import '../drawer_pages/withdraw_history.dart';
import '../register_pages/login_page.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  var signInToken, userName;

  Home([this.signInToken, this.userName]);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeState();
  }
}

CustomColors customColors = CustomColors();
var token;
int? g_sign;
var p_img_path;

class homeState extends State<Home> {
  SharedPreferences? prefs;
  _getPrefsData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs!.getString("session_token")!;
    g_sign = prefs!.getInt("googleSign");
    // p_img_path = prefs!.getString("img_path");
    // print("imgPath in home: " + p_img_path);
  }

  homeState() {
    _getPrefsData();
  }
  _signOutApi() async {
      _getPrefsData();
    CustomProgressDialogue.progressDialogue(context);
    if (g_sign == 1) {
      await GoogleSignInApi.logout();
    }

    print("Token inside signout: " + token.toString());
    await http
        .post(
      Uri.parse("http://backend.ourlifechanger.com/public/api/destroy"),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      encoding: Encoding.getByName("utf-8"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        print(json.decode(response.body));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
    prefs!.remove("session_token");
    prefs!.remove("googleSign");
  }

  CallApi _api = CallApi();
  var count;
  dynamic annoucementList = [];
  Future<void> _getObjectives() async {
    //  _getPrefsData();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //token = "602|CzOAqewpH0zVl6AIhXvjfCjCKpOicsNLbXQK0MKm";
    token = preferences.getString("session_token");
    await _api.fetchDashboard("announcements-count", token);

    var res = await _api.response;
    count = res['count'];
    print("Count: " + res['count'].toString());

    //  int  child_count=refList['childs_count'];
    //   print("Count: "+child_count.toString());

    //int count = 0;

    // print("ChildList: " + childList.toString());
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _getObjectives();
    });
    // TODO: implement build
    // print("Token in Home:  " + widget.signInToken.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Lifechanger"),
        backgroundColor: customColors.background,
        //leading: Icon(Icons.web),
        actions: [
          Row(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Mycolors.yellow),
                  padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                ),
                child: Text(
                  widget.userName == null ? " User Name" : widget.userName,
                  style: TextStyle(color: Mycolors.darkPurple),
                ),
                onPressed: null,
              ),
              NamedIcon(
                text: 'Inbox',
                iconData: Icons.notifications,
                notificationCount: count != null ? count : 0,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AllNotification(),
                    ),
                  );
                },
              ),
              IconButton(
                  icon: Icon(Icons.logout),
                  color: Colors.white,
                  onPressed: () {
                    _signOutApi();
                  }),
            ],
          ),
        ],
      ),
      drawer: NavigationDrawer(userName: widget.userName),
      body: DashBoard(),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  var userName;
  NavigationDrawer({required this.userName});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      backgroundColor: customColors.purpleDark,
      child: SingleChildScrollView(
        child: Container(
          color: customColors.purpleDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(context, userName),
              buildMenu(context),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildHeader(BuildContext context, var userName) {
  return Material(
    color: customColors.background,
    child: InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Profile(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(
            top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(ProfileState.imagePathProfile !=
                      null
                  ? ProfileState.imagePathProfile
                  : "https://backend.ourlifechanger.com/public/images/1684997634.jpg"),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              userName,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildMenu(BuildContext context) {
  return Container(
    color: customColors.purpleDark,
    child: Wrap(
      // runSpacing: 10,
      children: [
        ListTile(
          leading: Icon(
            Icons.dashboard,
            color: Colors.white,
          ),
          title: Text(
            "Dashboard",
            style: TextStyle(color: Colors.white),
          ),
          // selectedColor: customColors.yellowhigh,
          //tileColor: customColors.,
          selectedTileColor: customColors.yellowhigh,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        Divider(
          color: customColors.purpleLight,
        ),
        ListTile(
          leading: Icon(
            Icons.video_call_sharp,
            color: Colors.white,
          ),
          title: Text(
            "View Cash Videos",
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AvaliableAds(),
              ),
            );
          },
        ),
        Divider(
          color: customColors.purpleLight,
        ),
        ListTile(
          leading: Icon(
            Icons.upgrade_sharp,
            color: Colors.white,
          ),
          title: Text(
            "Upgrade Plan",
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AllPackegs(),
              ),
            );
          },
        ),
        Divider(
          color: customColors.purpleLight,
        ),
        ListTile(
          leading: Icon(
            Icons.link_sharp,
            color: Colors.white,
          ),
          title: Text(
            "My Referrals and links",
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Referral(),
              ),
            );
          },
        ),
        Divider(
          color: customColors.purpleLight,
        ),
        ListTile(
          leading: Icon(
            Icons.money_sharp,
            color: Colors.white,
          ),
          title: Text(
            "Deposit Balance",
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DepositBalance(),
              ),
            );
          },
        ),
        Divider(
          color: customColors.purpleLight,
        ),
        ListTile(
          leading: Icon(
            Icons.money_off_sharp,
            color: Colors.white,
          ),
          title: Text(
            "Withdraw Balance",
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WithDraw(),
              ),
            );
          },
        ),
        Divider(
          color: customColors.purpleLight,
        ),
        ListTile(
          leading: Icon(
            Icons.history_edu,
            color: Colors.white,
          ),
          title: Text(
            "Deposit History",
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DepositHistory(),
              ),
            );
          },
        ),
        Divider(
          color: customColors.purpleLight,
        ),
        ListTile(
          leading: Icon(
            Icons.history_edu,
            color: Colors.white,
          ),
          title: Text(
            "Withdraw History",
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WithDrawlHistory(),
              ),
            );
          },
        ),
        Divider(
          color: customColors.purpleLight,
        ),
        ListTile(
          leading: Icon(
            Icons.history_edu,
            color: Colors.white,
          ),
          title: Text(
            "Earnings History",
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EarningHistory(),
              ),
            );
          },
        ),
        Divider(
          color: customColors.purpleLight,
        ),
      ],
    ),
  );
}
