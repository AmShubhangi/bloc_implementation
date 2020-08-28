import 'dart:async';

import 'package:meta/meta.dart';
import 'package:user_repository/src/interfaces/api_interfaces.dart';

class UserRepository {
  String loginResponse = "";

// Login and get sessionToken
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    var res = await APIInterfaces.loginUser(username, password);
    print("Error Response ==>> $res");
    if (res.containsKey('code')) {
      APIInterfaces.handleAPIError(res);
      loginResponse = res['code'];
      print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww$loginResponse}");

      return loginResponse;

    } else {
      loginResponse = res['sessionToken'];
      print('Login Response ==>> $loginResponse');
      return loginResponse;
    }
//    print('Login Response ==>> $loginResponse');
//    return loginResponse;
  }

// Get UserProfile Data
  Future<dynamic> getUserProfile({@required String sessionToken}) async {
    try {
      var res = await APIInterfaces.getUserProfile(sessionToken);
      return res;
    } catch (res) {
      return APIInterfaces.handleAPIError(res);
    }
  }

// Get Account Data
  Future<dynamic> getAccounts({@required String sessionToken}) async {
    try {
      var resAccounts = await APIInterfaces.getAccounts(sessionToken);
      var accountData = resAccounts[0];
      return accountData;
    } catch (res) {
      return APIInterfaces.handleAPIError(res);
    }
  }

// Get Account Data
  Future<dynamic> getAccountsHistory(
      {@required String sessionToken, @required String accountType}) async {
    try {
      var resAccountsHistory =
          await APIInterfaces.getAccountsHistory(sessionToken, accountType);
      return resAccountsHistory;
    } catch (res) {
      return APIInterfaces.handleAPIError(res);
    }
  }

// Get Transaction Detail
  Future<dynamic> getTransactionDetail(
      {@required String sessionToken,
      @required String transactionNumber}) async {
    try {
      var resTransactionDetail = await APIInterfaces.getTransactionDetail(
          sessionToken, transactionNumber);
      return resTransactionDetail;
    } catch (res) {
      return APIInterfaces.handleAPIError(res);
    }
  }

//  // ignore: missing_return
//  Future<dynamic> handleAPIError(dynamic res) {
//    print('handleAPIError ==>> $res');
//    print('handleAPIError ==>> ${res['code']}');
////    setState(() {
////      isLoading = false;
////    });
//    if (res['code'] == 'login') {
////      _alertLoginError();
//      print('Facing Some Issue in your email and password! ==>> $res');
//      return null;
//    } else if (res['code'] == 'loggedOut') {
//      return null;
//    }
//  }
}
