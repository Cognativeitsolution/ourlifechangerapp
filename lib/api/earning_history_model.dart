class EarningHi {
  final String transid;
  final String credit;
  final String gateway;
  final String earningsource;
  final String status;
  final String date;

  const EarningHi({
    required this.transid,
    required this.credit,
    required this.gateway,
    required this.earningsource,
    required this.status,
    required this.date,
  });

  factory EarningHi.fromJson(Map<String, dynamic> json) {
    return EarningHi(
      transid: json['tid'],
      credit: json['credit'],
      gateway: json['gateway_type'],
      earningsource: json['earning_source'],
      status: json['status'],
      date: json['created_at'],
    );
  }
}
