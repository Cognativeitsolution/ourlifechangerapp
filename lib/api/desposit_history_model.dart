class DepositH {
  final String transid;
  final String deposit;
  final String gateway;
  final String user;
  //final String earningsource;
  final String status;
  final String date;

  const DepositH({
    required this.transid,
    required this.deposit,
    required this.gateway,
    required this.user,
   // required this.earningsource,
    required this.status,
    required this.date,
  });

  factory DepositH.fromJson(Map<String, dynamic> json) {
    return DepositH(
      transid: json['tid'],
      deposit: json['deposit'],
      gateway: json['gateway_type'],
      user: json['user'],
      //earningsource: json['earning_source'],
      status: json['status'],
      date: json['created_at'],
    );
  }
}
