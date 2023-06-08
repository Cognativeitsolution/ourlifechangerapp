import 'package:flutter/material.dart';

import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:lifechangerapp/colors/colors.dart';

class ChatApp extends StatelessWidget {
  ChatApp({Key? key}) : super(key: key);
  CustomColors _customColors = CustomColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Tawk'),
        backgroundColor: _customColors.background,
        elevation: 0,
      ),
      body: Tawk(
        directChatLink:
            'https://tawk.to/chat/6458c9816a9aad4bc5797be5/1gvtd68gv',
        visitor: TawkVisitor(
          name: 'Ahmed',
          email: 'kaber596@gmail.com',
        ),
        onLoad: () {
          print('Hello Tawk!');
        },
        onLinkTap: (String url) {
          print(url);
        },
        placeholder: const Center(
          child: Text('Loading...'),
        ),
      ),
    );
  }
}
