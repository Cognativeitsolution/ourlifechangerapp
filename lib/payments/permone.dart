import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Permoney extends StatefulWidget {
  Permoney({super.key, required this.amount}) {
    print("Constructor called");
  }

  final double amount;

  @override
  State<Permoney> createState() => _PermoneyState();
}

class _PermoneyState extends State<Permoney> {
     WebViewController? controller;
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    print("Inside perfect money class");
    return Scaffold(
        appBar: AppBar(
          title: Text('Perfect Money'),
        ),
        body: InAppWebView(
            initialData: InAppWebViewInitialData(data: '''

<html>

<head>
    <title>Perfect Money - Way to develop your money.</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="Expires" content="Thu, 01 Dec 1994 16:00:00 GMT">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="Last-Modified" content="">
    <meta http-equiv="Pragma" content="no-cache">
    <link rel="stylesheet" type="text/css" href="/css/keyboard.css">
    <style type="text/css">
        .top {
        font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 8pt
        }
        
        .req {
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 9pt;
            color: #FF0000
        }
        
        td {
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 13px;
            color: #333333
        }
        
        .ag {
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 11px;
            color: #333333
        }
        
        h2 {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 15pt;
            color: #333333
        }
        
        #TJK_ToggleON,
        #TJK_ToggleOFF {
            display: none
        }
        
        .menu {
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 10pt
        }
        
        .txt {
            text-align: justify
        }
        
        a {
            color: #990000
        }
    </style>
    <link rel="stylesheet" href="/style.css">
    <link rel="StyleSheet" href="/css/style.css" type="text/css">

    <script type="text/javascript" src="/js/toggle/toggle.js"></script>
    <link href="/js/toggle/toggle.css" type="text/css" rel="stylesheet">
    <link href="/js/toggle/toggle_ie5mac.css" type="text/css" rel="stylesheet">
    <script type="text/javascript" src="/js/keyboard.js" charset="UTF-8"></script>
</head>

<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" id="auth" cz-shortcut-listen="true">


    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tbody>
            <tr>
                <td height="43"><img src="/img/blank.gif" width="900" height="15"><br>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td width="10%" nowrap=""><img src="/img/blank.gif" width="14" height="26">
                                                    <a href="https://perfectmoney.com" target="_blank"><img border="0" src="https://perfectmoney.com/img/logo3.png" width="306" height="63"></a>
                                                </td>
                                                <td align="right" valign="bottom">
                                                </td>
                                                <td align="right" valign="top" width="3%">&nbsp;</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <font face="Verdana, Arial, Helvetica, sans-serif" size="2"><br>
                                    </font>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>



    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tbody>
            <tr>

                <td width="38"><img src="/img/blank.gif" width="38" height="26"></td>
                <td width="94%">

                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr background="/img/bgg.gif">
                                <td colspan="2" valign="top" background="/img/bgg.gif">


                                    <table border="0" width="100%" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr bgcolor="#FFFFFF">
                                                <td height="13" valign="middle" nowrap="" width="99%"> <span id="actions"></span>
                                                    <img src="/img/red.gif" width="100%" height="1"><noscript> </noscript>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <br><br>

                                    <table width="550" border="0" cellspacing="0" cellpadding="1" align="center" bgcolor="#1C52AF">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="5" align="center" bgcolor="#FFFFFF">
                                                        <tbody>
                                                            <tr>
                                                                <td>

                                                                    <div style="padding: 15px 15px 15px 15px;">
                                                                        <form action="https://perfectmoney.com/api/step1.asp" method="POST">

                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td nowrap="" width="500">
                                                                                            <h1><img src="/img/blank.gif" width="14" height="8"><br>&nbsp;
                                                                                                <font color="#F01010">Perfect Money®</font> payment order</h1>
                                                                                        </td>
                                                                                        <td nowrap="">
                                                                                            <div align="right"><img src="https://perfectmoney.com/img/lock4.jpg">&nbsp;&nbsp;Secure Transfer&nbsp;&nbsp;&nbsp;</div>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>

                                                                            <div class="error"></div>


                                                                            <table cellpadding="5">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td>Payment to:</td>
                                                                                        <td><b>U40614053 </b><b>(Saad)</b></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>Amount:</td>
                                                                                        <td><b>${widget.amount} USD</b></td>
                                                                                    </tr>

                                                                                </tbody>
                                                                            </table>


                                                                            <table cellpadding="5">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <br>
                                                                                            <xb>
                                                                                                <font size="2">Please select desired payment method:</font>
                                                                                            </xb><br><img src="/img/blank.gif" width="7" height="5"><br><br>

                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                <tbody>
                                                                                                    <tr>
                                                                                                                                               <td valign="top" width="30"> <img src="/img/blank.gif" width="7" height="5"><br><input style="background-color:White; border-color:White; border-style:none; border-width:0;" type="radio"
                                                                                                                name="FORCED_PAYMENT_METHOD" value="account" checked="" id="r_account">
                                                                                                        </td>
                                                                                                        <td nowrap="" valign="top"><img src="/img/blank.gif" width="7" height="5"><br><label for="r_account"><b>Perfect Money account</b></label><br>
                                                                                                            <img src="/img/blank.gif" width="7" height="5"><br> Pay from existing Perfect Money account
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </tbody>
                                                                                            </table>
                                                                                            <img src="/img/blank.gif" width="10" height="10"><br>


                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                <tbody>
                                                                                                    <tr>
                                                                                                        <td valign="top" width="61"><img src="https://perfectmoney.com/img/pm3.jpg" border="0"></td>
                                                                                                        <td valign="top" width="30"> <img src="/img/blank.gif" width="7" height="5"><br><input style="background-color:White; border-color:White; border-style:none; border-width:0;" type="radio"
                                                                                                                name="FORCED_PAYMENT_METHOD" value="voucher" id="r_voucher">
                                                                                                        </td>
                                                                                                        <td nowrap="" valign="top"><img src="/img/blank.gif" width="7" height="5"><br><label for="r_voucher"><b>e-Voucher / Prepaid Card</b></label><br>
                                                                                                            <img src="/img/blank.gif" width="7" height="5"><br> Pay with Perfect Money e-Voucher
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </tbody>
                                                                                            </table>
                                                                                            <img src="/img/blank.gif" width="10" height="10"><br>







                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>

                                                                            <table cellpadding="5">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td valign="top"><input type="submit" name="action" class="button" value="Make payment"></td>
                                                                                        <td valign="top">
                                                                                            <form action="https://perfectmoney.com/api" method="POST">
                                                                                                <input type="hidden" name="PAYEE_NAME" value="Saad" class="form-control" readonly>
                                                                                                <input type="hidden" name="PAYEE_ACCOUNT" value="U40614053">
                                                                                                <input type="hidden" name="PAYMENT_AMOUNT" value="${widget.amount}">
                                                                                                <input type="hidden" name="PAYMENT_UNITS" value="USD">
                                                                                                <input type="hidden" name="PAYMENT_URL" value="http://localhost/perfectmoney/">
                                                                                                <input type="hidden" name="NOPAYMENT_URL" value="http://localhost/perfectmoney/">
                                                                                                <input type="hidden" name="PAYMENT_ID" value="NULL">
                                                                                                <input type="hidden" name="SUGGESTED_MEMO" value="">
                                                                                                <input type="hidden" name="PAYMENT_BATCH_NUM" value="0">
                                                                                                <input type="hidden" name="ORDER_NUM" value="">
                                                                                                <input type="hidden" name="CUST_NUM" value="">
                                                                                                <input type="submit" class="button" value="Cancel payment" style="border-color:#EAEAEA;background:#F8F8F8;">
                                                                                            </form>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </form>
                                                                    </div>

                                                                </td>
                                                            </tr>

                                                        </tbody>
                                                    </table>

                                                </td>
                                            </tr>

                                        </tbody>
                                    </table>

                                    <br><br>


                                </td>
                            </tr>

                            <tr valign="middle">
                                <td bgcolor="#FFFFFF" valign="middle" height="12"><img src="/img/red.gif" width="100%" height="1"></td>
                            </tr>


                        </tbody>
                    </table>
                </td>
                <td width="3%" valign="middle"><img src="/img/blank.gif" width="24" height="26"></td>
            </tr>
        </tbody>
    </table>

    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tbody>
            <tr>
                <td height="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td width="1%"><img src="/img/bl.gif" width="19" height="6"></td>
                                <td width="98%" bgcolor="1C52AF"><img src="/img/blank.gif" width="1" height="1"></td>
                                <td width="1%" valign="middle"><img src="/img/br.gif" width="19" height="6"></td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>



    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tbody>
            <tr>
                <td bgcolor="#ffffff" valign="top" height="56">
                    <div align="left">
                        <table width="100%" border="0" cellspacing="5" cellpadding="5">
                            <tbody>
                                <tr>
                                    <td>
                                        <div align="left"><small>
                                                <font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b>
                                                        Are you a webmaster?</b> <br>
                                                    Please <a href="https://perfectmoney.com" target="_blank">click here</a> to accept payments on your website in such an easy way. Instant approval.</font>
                                            </small></div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </td>
                <td bgcolor="#ffffff" valign="top" height="56">
                    <table width="500" border="0" cellspacing="5" cellpadding="5" align="right">
                        <tbody>
                            <tr>
                                <td>
                                    <div align="right"><small>
                                            <font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                                                © 2023 SR &amp; I. All rights reserved.&nbsp;
                                                <br>
                                                <a href="/legal.html">
                                                    <font color="#b50b0b">Legal notice</font>
                                                </a>
                                                | <a href="/privacy.html">
                                                    <font color="#b50b0b">Privacy policy</font>
                                                </a><small>
                                                    <font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                                                        | <a href="/tos.html">
                                                            <font color="#b50b0b">Terms of Use</font>
                                                        </a></font>
                                                </small> &nbsp;
                                        </font>
                                        </small>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>





</body>

</html>



'''),
            onWebViewCreated: (InAppWebViewController webViewController) async {
              _webViewController = webViewController;
            }));
  }
}
