import 'package:user_repository/user_repository.dart';

UserRepository userRepository = new UserRepository();
class TransactionSection {
  // ignore: non_constant_identifier_names
//  UserRepository userRepository = new UserRepository();
  Future<String> TransactionName() {
  }

  static Future<dynamic> getTransactionDetail(String token, String transactionNumber) async {
    var response = await userRepository.getTransactionDetail(
        sessionToken: token, transactionNumber: transactionNumber);
    return response;
  }
}