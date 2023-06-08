import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lifechangerapp/colors/colors.dart';

class JazzCashDeposit extends StatefulWidget {
  var amount;
  JazzCashDeposit({Key, key, required this.amount}) : super(key: key);

  @override
  _JazzCashDepositState createState() => _JazzCashDepositState();
}

class _JazzCashDepositState extends State<JazzCashDeposit> {
  CustomColors _customColors = CustomColors();
  var responcePrice;
  bool isLoading = false;
  payment() async {
    setState(() {
      isLoading = true;
    });

    var digest;
    String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    String dexpiredate = DateFormat("yyyyMMddHHmmss")
        .format(DateTime.now().add(const Duration(days: 1)));
    String tre = "T" + dateandtime;
    String pp_Amount = widget.amount; // price set
    String pp_BillReference = "billRef";
    String pp_Description = "Description for transaction";
    String pp_Language = "EN";
    String pp_MerchantID = "MC55247";
    String pp_Password = "v2yxz0b00x";

    String pp_ReturnURL =
        "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction";
    String pp_ver = "1.1";
    String pp_TxnCurrency = "PKR";
    String pp_TxnDateTime = dateandtime.toString();
    String pp_TxnExpiryDateTime = dexpiredate.toString();
    String pp_TxnRefNo = tre.toString();
    String pp_TxnType = "MWALLET";
    String ppmpf_1 = "923360501522";
    String IntegeritySalt = "1c24twf40x";
    String and = '&';
    String superdata = IntegeritySalt +
        and +
        pp_Amount +
        and +
        pp_BillReference +
        and +
        pp_Description +
        and +
        pp_Language +
        and +
        pp_MerchantID +
        and +
        pp_Password +
        and +
        pp_ReturnURL +
        and +
        pp_TxnCurrency +
        and +
        pp_TxnDateTime +
        and +
        pp_TxnExpiryDateTime +
        and +
        pp_TxnRefNo +
        and +
        pp_TxnType +
        and +
        pp_ver +
        and +
        ppmpf_1;

    var key = utf8.encode(IntegeritySalt);
    var bytes = utf8.encode(superdata);
    var hmacSha256 = Hmac(sha256, key);
    Digest sha256Result = hmacSha256.convert(bytes);
    String url =
        'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction';

    var response = await http.post(Uri.parse(url), body: {
      "pp_Version": pp_ver,
      "pp_TxnType": pp_TxnType,
      "pp_Language": pp_Language,
      "pp_MerchantID": pp_MerchantID,
      "pp_Password": pp_Password,
      "pp_TxnRefNo": tre,
      "pp_Amount": pp_Amount,
      "pp_TxnCurrency": pp_TxnCurrency,
      "pp_TxnDateTime": dateandtime,
      "pp_BillReference": pp_BillReference,
      "pp_Description": pp_Description,
      "pp_TxnExpiryDateTime": dexpiredate,
      "pp_ReturnURL": pp_ReturnURL,
      "pp_SecureHash": sha256Result.toString(),
      "ppmpf_1": "923360501522"
    });

    print("response=>");
    print(response.statusCode.toString());
    print(response.body);
    var res = await response.body;
    var body = jsonDecode(res);
    responcePrice = body['pp_Amount'];
    final snackBar = SnackBar(
      content: Text("payment successfull ${responcePrice}"),
      backgroundColor: (Colors.black),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.of(context).pop();
    // Fluttertoast.showToast(msg: "payment successfully ${responcePrice}");
    setState(() {
      isLoading = false;
    });
  }

// i will share code in description
  // use you apis . you can create account in jazz cash developers i will shre link thanks
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text("Amout to Deposit:  " + widget.amount),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              payment();
                            },
                            child: Text("Click to pay JazzCash"),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  _customColors.purpleDark),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(15)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
