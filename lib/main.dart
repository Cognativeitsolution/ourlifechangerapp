import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'splash_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppStat();
  }
}

class MyAppStat extends State<MyApp> {
  final Color _primaryColor = HexColor("482469");
  final Color _accentColor = HexColor("8C4FC0");

  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: _accentColor),
        scaffoldBackgroundColor: Colors.grey.shade100,
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(),
    );
  }
}
