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

class Withdraw_History {
  var sn, transactionID, paymentGateway, dt, status;
  Withdraw_History(
      [this.sn, this.transactionID, this.paymentGateway, this.dt, this.status]);
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

class Earning_History {
  var sn,
      transactionID,
      amount,
      account,
      fundedAmount,
      paymentGateway,
      dt,
      status;
  Earning_History(
      [this.sn,
      this.transactionID,
      this.amount,
      this.account,
      this.fundedAmount,
      this.paymentGateway,
      this.dt,
      this.status]);
}
