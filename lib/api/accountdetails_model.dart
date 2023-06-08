class AccountDetails {
  String jazzcashaccount;
  String jazzcashname;
  String easypaisaaccount;
  String easypaisaname;

  AccountDetails({
    required this.jazzcashaccount,
    required this.jazzcashname,
    required this.easypaisaaccount,
    required this.easypaisaname,
  });

  factory AccountDetails.fromJson(Map<String, dynamic> json) {
    return AccountDetails(
      jazzcashaccount: json['jazzcash_account_number'],
      jazzcashname: json['jazzcash_account_title'],
      easypaisaaccount: json['easypaisa_account_number'],
      easypaisaname: json['easypaisa_account_title'],
    );
  }

  Map<String, dynamic> toJson() => {
        "jazzcash_account_number": jazzcashaccount,
        "jazzcash_account_title": jazzcashname,
        "easypaisa_account_number": easypaisaaccount,
        "easypaisa_account_title": easypaisaname,
      };
}
