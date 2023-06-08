import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:lifechangerapp/common/custom_dialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../api/app_utils.dart';
import '../api/profile_model.dart';
import '../colors/colors.dart';
import '../common/custom_button.dart';
import 'profile.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({required this.profile, super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
  final ProfileData profile;
}

var token;

String apiUrl = "https://backend.ourlifechanger.com/public/api/edit-profile";

class _EditProfileState extends State<EditProfile> {
  _EditProfileState() {
    _getToken();
  }

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('session_token');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.darkPurple,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: GestureDetector(
                onTap: showSelectionDialog,
                child: Container(
                  height: 250,
                  width: 250,
                  child: CircleAvatar(
                    backgroundColor: Mycolors.lightPurple,
                    backgroundImage: imagePath == null
                        ? NetworkImage(
                            "https://backend.ourlifechanger.com/public/images/${widget.profile.image}")
                        : FileImage(imagePath!) as ImageProvider,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                  onTap: () {
                    // updateImage();
                    if (imagePath == null) {
                    } else {
                      setState(() {});
                      upload();
                      print("object");
                    }
                  },
                  buttonText: "Update Profile",
                  sizeWidth: double.infinity),
            ),
          ],
        ),
      ),
    );
  }

  // Future updateImage() async {
  //   var request = http.MultipartRequest(
  //     "POST",
  //     Uri.parse('https://backend.ourlifechanger.com/public/api/update-profile'),
  //   );
  //   Map<String, String> headers = {"Content-type": "multipart/form-data"};
  //   Map<String, String> method = {'_method': 'PUT'};
  //   request.headers.addAll(headers);

  //   request.files.add(http.MultipartFile.fromBytes(
  //       "image", File(_image!.path).readAsBytesSync(),
  //       filename: _image!.path));
  //   request.fields.addAll(method);
  //   var res = await request.send();
  //   if (res.statusCode == 200) {
  //     print("Data uploaded");
  //   } else {
  //     print(res.statusCode);
  //   }
  // }

  final ImagePicker _picker = ImagePicker();

  static var length;
  static dynamic imagePath;
  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    File mimage = File(image!.path);
    // print(image);
    if (mimage != null) {
      setState(() {
        imagePath = mimage;
        print("Image Path" + imagePath.path);
        length = imagePath!.length;
        print("NowLength" + length.toString());
      });
    }
  }

  Future showSelectionDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Select photo'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('From gallery'),
              onPressed: () {
                getImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text('Take a photo'),
              onPressed: () {
                getImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  upload() async {
    CustomProgressDialogue.progressDialogue(context);
    File imageFile = File(imagePath.path);
    var stream = http.ByteStream(imageFile.openRead());
    // var stream=http.ByteStream(DelegatingStream.typed(file.openRead()));
    stream.cast();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    var length = imageFile.length;
    //print("lengthimage:  " + length.toString());

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };

    Map<String, String> infoData = {
      '_method': 'PUT',
    };

    var fileExtension = AppUtils.getFileExtension(imageFile.toString());
    if (fileExtension.isEmpty) {
      print("Not found");
      return false;
    }

    var url = Uri.parse(
        "http://backend.ourlifechanger.com/public/api/update-profile");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields.addAll(infoData);

    final file = await http.MultipartFile.fromPath('image', imagePath.path,
        contentType: MediaType('application', fileExtension));
    // var multiport = http.MultipartFile(
    //     'profile_image',
    //     File(UP4.imagePath).readAsBytes().asStream(),
    //     File(UP4.imagePath).lengthSync(),
    //     filename: UP4.imagePath.split("/").last);
    request.files.add(file);
    var response = await request.send();
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      print("Data uploaded");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Updated Successfully",
          style: TextStyle(fontSize: 16),
        ),
      ));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Profile()));
    } else {
      print("Error uploading");
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Error Updating...",
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }
}