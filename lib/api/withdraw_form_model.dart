class Withdraw {
  final String? accountname;
  final String? accountnumber;
  final String? withdrawamount;
  final String? paymentgatway;
  final String? description;

  Withdraw(
      {required this.accountname,
      required this.accountnumber,
      required this.withdrawamount,
      required this.paymentgatway,
      required this.description});

  factory Withdraw.fromJson(Map<String, dynamic> json) {
    return Withdraw(
      accountname: json['account_name'],
      accountnumber: json['account_number'],
      withdrawamount: json['debit'],
      paymentgatway: json['gateway_type'],
      description: json['description'],
    );
  }
}
