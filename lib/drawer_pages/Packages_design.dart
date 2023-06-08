// import 'package:flutter/material.dart';
// import 'package:lifechangerapp/colors/colors.dart';
// import 'package:lifechangerapp/common/activeStatus.dart';
// import 'package:lifechangerapp/common/packages.dart';

// class ProductBox extends StatelessWidget {
//   ProductBox({Key? key, required this.item}) : super(key: key);
//   final PackagesInfo item;

//   Widget build(BuildContext context) {
//     CustomColors customColors = CustomColors();
//     return Container(
//         color: customColors.background,
//         padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//         // height: MediaQuery.of(context).size.height,
//         height: 300,
//         child: Card(
//           shadowColor: Colors.black,
//           elevation: 15,
//           color: customColors.background,
//           child: Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                 width: MediaQuery.of(context).size.width,
//                 color: customColors.purpleLight,
//                 height: 60,
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     this.item.name,
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20),
//                   ),
//                 ),
//               ),
//               Container(
//                 color: customColors.purpleDark,
//                 height: 30,
//                 padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                 width: MediaQuery.of(context).size.width,
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     "Rs. " + this.item.price,
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
//                 child: Align(
//                   child: Text(
//                     this.item.description,
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 color: customColors.purpleDark,
//                 height: 30,
//                 padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                 width: MediaQuery.of(context).size.width,
//                 margin: EdgeInsets.only(bottom: 5),
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     "Ad limit: " + this.item.adLimit,
//                     style: TextStyle(
//                       color: Colors.white,
//                       backgroundColor: customColors.purpleDark,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 color: customColors.purpleDark,
//                 height: 30,
//                 padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
//                 width: MediaQuery.of(context).size.width,
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         child: Text(
//                           "Duration: " + this.item.duration,
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         onPressed: null,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Expanded(
//                       child: ElevatedButton(
//                         child: Text(
//                           "End: " + "03/04/2023",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         onPressed: null,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                 margin: EdgeInsets.only(top: 10),
//                 child: ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.all(customColors.yellowhigh),
//                     foregroundColor: MaterialStateProperty.all(Colors.white),
//                     // padding: MaterialStateProperty.all(EdgeInsets.all(10)),
//                   ),
//                   child: Text(
//                     "Get Started",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   onPressed: null,
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
