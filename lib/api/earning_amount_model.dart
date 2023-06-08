class EarnimgAmount {
  final String? amount;

  EarnimgAmount({
    this.amount,
  });

  factory EarnimgAmount.fromJson(Map<String, dynamic> json) {
    return EarnimgAmount(
      amount: json['data']['watch_ad_amount'],
    );
  }

  Map<String, dynamic> toJson() => {
        "watch_ad_amount": amount,
      };

  @override
  String toString() {
    return 'data{watch_ad_amount: $amount,}';
  }
}
