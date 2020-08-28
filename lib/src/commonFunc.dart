import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:user_repository/user_repository.dart';

UserRepository userRepository = new UserRepository();

class TransactionSection {

 static Future<String> TransactionName(resTransactionDetails, transactionTitle) {
//    resTransactionDetails['transaction']['customValues'].map((i) =>
//    i['field']['internalName'] == 'Beneficiary_Company_Name'
//        ? (companyName = i['stringValue'])
//        : (companyName = transactionTitle));
//
//    resTransactionDetails['transaction']['customValues'].map((i) =>
//    i['field']['internalName'] == 'Beneficiary_First_Name'
//        ? (firstName = i['stringValue'])
//        : (firstName = transactionTitle));
//
//    resTransactionDetails['transaction']['customValues'].map((i) =>
//    i['field']['internalName'] == 'Beneficiary_Last_Name'
//        ? (lastName = i['stringValue'])
//        : (lastName = transactionTitle));
  }

  static Future<dynamic> getTransactionDetail(String token, String transactionNumber) async {
    var response = await userRepository.getTransactionDetail(
        sessionToken: token, transactionNumber: transactionNumber);
    return response;
  }


// alertLoginError() {
//   Alert(
//     context: context,
//     title: 'Please enter proper credentials.',
//     buttons: [
//       DialogButton(
//         color: Color.fromRGBO(17, 17, 68, 1),
//         child: Text(
//           'Close',
//           style: TextStyle(color: Colors.white),
//         ),
//         onPressed: () {
//           FocusScope.of(context).requestFocus(focusUsername);
//           _controllerUserName.clear();
//           _controllerPassword.clear();
//           Navigator.of(context, rootNavigator: true).pop();
//         },
//         width: 120,
//       )
//     ],
//   ).show();
// }
}