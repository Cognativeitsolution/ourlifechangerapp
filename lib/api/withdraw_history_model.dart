class WithdrawHi {
  final String? tid;
  final String? debit;
  final String? gateway;
  final String? accountno;
  final String? accountname;
  final String? withdraw;
  final String? date;
  final String? status;

  WithdrawHi({
    required this.tid,
    required this.debit,
    required this.gateway,
    required this.accountno,
    required this.accountname,
    required this.withdraw,
    required this.date,
    required this.status,
  });

  factory WithdrawHi.fromJson(Map<String, dynamic> json) {
    return WithdrawHi(
      tid: json['tid'],
      debit: json['debit'],
      gateway: json['gateway_type'],
      accountno: json['account_number'],
      accountname: json['account_name'],
      withdraw: json['is_withdraw'],
      date: json['created_at'],
      status: json['status'],
    );
  }
}
