import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class APIInterfaces {
  static Future<dynamic> loginUser(String username, String password) async {
    try {
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      Map<String, String> headers = {
        'authorization': basicAuth,
        'accept': 'application/json',
        'channel': 'mobile'
      };
      final body = {};
      var uri = Uri.parse('https://dev.backend.fvbank.us/api/auth/session');
      uri = uri
          .replace(queryParameters: <String, String>{'fields': 'sessionToken'});
      final response = await http.post(uri, headers: headers, body: body);
      return jsonDecode(response.body);
    } catch (e) {
      print('Error Catch ==>> $e');
      return handleAPIError(e);
    }
  }

  static Future<dynamic> getUserProfile(String sessionToken) async {
    try {
      Map<String, String> headers = {
        'session-token': sessionToken,
        'accept': 'application/json',
        'channel': 'mobile'
      };
      var uri = Uri.parse('https://dev.backend.fvbank.us/api/users/self');
      uri = uri.replace(queryParameters: <String, List<String>>{
        'fields': [
          'display',
          'email',
          'group.name',
          'addresses',
          'phones',
          'image.url',
          'shortDisplay',
          'registrationDate',
          'customValues'
        ]
      });
      final response = await http.get(uri, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return handleAPIError(e);
    }
  }

  static Future<dynamic> getAccounts(String sessionToken) async {
    try {
      Map<String, String> headers = {
        'session-token': sessionToken,
        'accept': 'application/json',
        'channel': 'mobile'
      };
      var uri = Uri.parse('https://dev.backend.fvbank.us/api/self/accounts');
      uri = uri.replace(queryParameters: <String, List<String>>{
        'fields': [
          'currency.name',
          'currency.symbol',
          'currency.prefix',
          'currency.decimalDigits',
          'status.availableBalance',
          'type',
          'number'
        ]
      });
      final response = await http.get(uri, headers: headers);

      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return handleAPIError(e);
    }
  }

  static Future<dynamic> getAccountsHistory(
      String sessionToken, String accountType) async {
    try {
      Map<String, String> headers = {
        'session-token': sessionToken,
        'accept': 'application/json',
        'channel': 'mobile'
      };
      var uri = Uri.parse(
          'https://dev.backend.fvbank.us/api/self/accounts/$accountType/history');
      uri = uri.replace(queryParameters: <String, dynamic>{
        'page': '0',
        'pageSize': '10',
        'skipTotalCount': 'true',
        'fields': [
          'transactionNumber',
          'date',
          'amount',
          'type.name',
          'type.to',
          'description'
        ]
      });
      final response = await http.get(uri, headers: headers);

      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return handleAPIError(e);
    }
  }

  static Future<dynamic> getTransactionDetail(
      String sessionToken, String transactionNumber) async {
    try {
      Map<String, String> headers = {
        'session-token': sessionToken,
        'accept': 'application/json',
        'channel': 'mobile'
      };
      var uri = Uri.parse(
          'https://dev.backend.fvbank.us/api/transfers/$transactionNumber');
      uri = uri.replace(queryParameters: <String, dynamic>{'fields': []});
      final response = await http.get(uri, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return handleAPIError(e);
    }
  }

 static handleAPIError(dynamic res) {
    print('handleAPIError ==>> $res');
    print('handleAPIError ==>> ${res['code']}');
    if (res['code'] == 'login') {
      print('Facing Some Issue in your email and password! ==>> $res');
      return;
    } else if (res['code'] == 'loggedOut') {
      return;
    }
  }
}
