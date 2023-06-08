import 'dart:convert';

import 'package:http/http.dart' as http;

class CallApi {
  int? index;
  CallApi([this.index]);
  final String baseURL = "http://backend.ourlifechanger.com/public/api/";

  postData(data, ApiUrl) async {
    var url = baseURL + ApiUrl;
    return await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
  var response, name, code;

  Future<void> fetchDashboard(apiUrl, token) async {
    var url = baseURL + apiUrl;
    var result =
        await http.get(Uri.parse(url), headers: _setauthHeaders(token));
    response = json.decode(result.body)['data'];
    //print("id " + response.toString());
    return json.decode(result.body)['data'];
  }

  int depo(dynamic deposit) {
    return deposit['deposit'];
  }

  String ref(dynamic referral) {
    return referral['referral'];
  }

  String wd(dynamic withdraw) {
    return withdraw['withdraw'];
  }

  String tBal(dynamic total) {
    return total['total_balance'];
  }

  var objective_fetch;

  Future<List<dynamic>> fetchObjectives(apiUrl, token) async {
    var url = baseURL + apiUrl;
    print("tokenValue: " + token);
    var result =
        await http.get(Uri.parse(url), headers: _setauthHeaders(token));
    response = json.decode(result.body)['data'] as List;
    // print("Fetch Response " + response.toString());
    // objective_fetch =
    //     json.decode(result.body)['data'][1];
    // print("object " + objective_fetch);
    return json.decode(result.body)['data'] as List;
  }

  Future<List<dynamic>> fetchInfo(apiUrl, token) async {
    var url = baseURL + apiUrl;
    print("tokenValue: " + token);
    var result =
        await http.get(Uri.parse(url), headers: _setauthHeaders(token));
    response = json.decode(result.body)['data'] as List;
    // print("Fetch Response " + response.toString());
    //objective_fetch = json.decode(result.body)['data'][0]["childs"]['name'];
    //print("object " + objective_fetch );
    return json.decode(result.body)['data'] as List;
  }

  Future<List<dynamic>> fetchCerts(apiUrl, token) async {
    var url = baseURL + apiUrl;
    print("tokenValue: " + token);
    var result =
        await http.get(Uri.parse(url), headers: _setauthHeaders(token));
    response = json.decode(result.body)['data'] as List;
    print("Fetch Response " + response.toString());
    // objective_fetch = json.decode(result.body)['data'][0]['title'];
    // print("object " + objective_fetch);
    return json.decode(result.body)['data'] as List;
  }

  postInfoData(data, ApiUrl, token) async {
    var url = baseURL + ApiUrl;
    return await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: _setauthHeaders(token),
    );
  }

  updateInfoData(data, ApiUrl, token) async {
    var url = baseURL + ApiUrl;
    return await http.put(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: _setauthHeaders(token),
    );
  }

  deleteInfoData(data, ApiUrl, token) async {
    var url = baseURL + ApiUrl;
    return await http.delete(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: _setauthHeaders(token),
    );
  }

  _setauthHeaders(String? token) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
}
