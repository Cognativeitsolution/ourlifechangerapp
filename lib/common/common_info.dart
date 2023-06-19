import 'package:internet_connection_checker/internet_connection_checker.dart';

class Info {
  var ip, os, browser, device, time;
  Info(
      {required this.ip,
      required this.os,
      required this.device,
      required this.browser,
      required this.time});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      ip: json['user_ip'],
      os: json['user_os'],
      device: json['user_device'],
      browser: json['user_browser'],
      time: json['time'],
    );
  }
}

class Refers {
  var sn, name, country, membership, totalEarn, todayEarn, status, jDate, eDate;
  Refers(
      [this.sn,
      this.name,
      this.country,
      this.membership,
      this.totalEarn,
      this.todayEarn,
      this.status,
      this.jDate,
      this.eDate]);
}

class Deposit_History {
  var sn, transactionID, amount, paymentGateway, dt, status;
  Deposit_History(
      [this.sn,
      this.transactionID,
      this.amount,
      this.paymentGateway,
      this.dt,
      this.status]);
}

class checkInternet {
  static Future<bool> checkNet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    // if (result == true) {
    //   print('YAY! Free cute dog pics!');
    // } else {
    //   print('No internet :( Reason:');
    //   //print(InternetConnectionChecker().lastTryResults);
    // }
    return result;
  }
}
