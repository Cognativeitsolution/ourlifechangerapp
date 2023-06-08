class Despositamount {
  final String deposit;
  final String paymentgatway;
  final String description;
  final String tid;
  final String status;

  Despositamount(
      {required this.deposit,
      required this.paymentgatway,
      required this.description,
      required this.tid,
      required this.status});

  factory Despositamount.fromJson(Map<String, dynamic> json) {
    return Despositamount(
        deposit: json['deposit'],
        paymentgatway: json['gateway_type'],
        description: json['description'],
        tid: json['tid'],
        status: json['status']);
  }
}
