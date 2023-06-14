// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/accountdetails_model.dart';
import '../api/profile_model.dart';
import '../colors/colors.dart';
import '../common/custom_text.dart';
import 'edit.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => ProfileState();
}

var token;

// String uid = Auth.uid;
String profileapiUrl =
    "https://backend.ourlifechanger.com/public/api/edit-profile";
String accountapiUrl =
    "https://backend.ourlifechanger.com/public/api/payment-info";

class ProfileState extends State<Profile> {
  static var imagePathProfile;
  _ProfileState() {
    _getToken();
  }

  SharedPreferences? prefs;
  _getToken() async {}

  //get Payment data functaion
  Future<AccountDetails> getaccountdetails() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs!.getString('session_token');
    var response = await http.get(
      Uri.parse(accountapiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer  $token',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return AccountDetails.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception("Error");
    }
  }

  //get Profile Data funcation
  Future<List<ProfileData>> getProfile() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs!.getString('session_token');
    var response = await http.get(
      Uri.parse(profileapiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer  $token',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      return (json.decode(response.body)['data'] as List)
          .map((e) => ProfileData.fromJson(e))
          .toList();
    } else {
      throw Exception("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.darkPurple,
        body: SingleChildScrollView(
          child: Column(
            children: [
              profileData(),
              accountDetail(),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileData() {
    return FutureBuilder<List<ProfileData>>(
      future: getProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ProfileData> data = snapshot.data as List<ProfileData>;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                imagePathProfile =
                    "https://backend.ourlifechanger.com/public/images/${data[index].image}";
                // prefs!.setString("img_path", imagePathProfile);

                print("ImagePath: " + imagePathProfile);
                return Column(
                  children: [
                    //Profile Image
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 140,
                          decoration: const BoxDecoration(
                            color: Mycolors.yellow,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 60,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        EditProfile(profile: data[index])),
                              );
                            },
                            child: SizedBox(
                              height: 140,
                              width: 140,
                              child: CircleAvatar(
                                backgroundColor: Mycolors.lightPurple,
                                backgroundImage: NetworkImage(
                                    "https://backend.ourlifechanger.com/public/images/${data[index].image}"),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -70,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Mycolors.yellow,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.edit,
                                color: Mycolors.darkPurple,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),

                    // Profile Data
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Mycolors.lightPurple,
                        ),
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: data[index].name,
                                    fontSize: 20,
                                  ),
                                  CustomText(
                                    text: data[index].package,
                                    fontSize: 25,
                                    textColor: Mycolors.yellow,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              const Divider(
                                thickness: 3,
                                color: Mycolors.yellow,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(text: "Username :"),
                                  CustomText(text: data[index].username)
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(text: "Name :"),
                                  CustomText(text: data[index].name)
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(text: "Email :"),
                                  CustomText(text: data[index].email)
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(text: "Contact :"),
                                  CustomText(text: data[index].contact)
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(text: "Email :"),
                                  CustomText(text: data[index].secemail!)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return const Center(
          child: CircularProgressIndicator(
            color: Mycolors.yellow,
          ),
        );
      },
    );
  }

  Widget accountDetail() {
    return FutureBuilder<AccountDetails>(
      future: getaccountdetails(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          AccountDetails data = snapshot.data as AccountDetails;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Mycolors.lightPurple,
              ),
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        CustomText(
                          text: "Account Details",
                          fontSize: 20,
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 3,
                      color: Mycolors.yellow,
                    ),

                    // Jazzcash Account
                    const CustomText(
                      text: "JazzCash Account",
                      textColor: Mycolors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: data.jazzcashname),
                        CustomText(text: data.jazzcashaccount)
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),

                    //Easypaisa Account
                    const CustomText(
                      text: "Easypaisa Account",
                      textColor: Mycolors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: data.easypaisaname),
                        CustomText(text: data.easypaisaaccount)
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return const Center();
      },
    );
  }
}
