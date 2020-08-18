class TransactionSection {
  String companyName = '';
  String firstName = '';
  String lastName = '';
  // ignore: non_constant_identifier_names
  Future<String> TransactionName(type,resTransactionDetails, transactionTitle) {
    print("type=> $type");
    if(type == "to")
    {
      if (resTransactionDetails['kind'] == 'payment') {
        if (resTransactionDetails.containsKey('transaction')) {
          var transactionData = resTransactionDetails['transaction'];
          if (transactionData.containsKey('customValues')) {
            var array = resTransactionDetails['transaction']['customValues'];
            for (int i = 0; i < array.length; i++) {
              var singleData = array[i];
              var val = singleData['field']['internalName'];
              if (val == 'Beneficiary_Company_Name') {
                companyName = singleData['stringValue'];
              }
              if (val == 'Beneficiary_First_Name') {
                firstName = singleData['stringValue'];
              }
              if (val == 'Beneficiary_Last_Name') {
                lastName = singleData['stringValue'];
              }
            }
          }
        }
        if (companyName != '') {
          transactionTitle = companyName;
        } else if (firstName != '' || lastName != '') {
          transactionTitle = '$firstName $lastName';
        } else if (companyName == '' || firstName == '' || lastName == '') {
          transactionTitle = resTransactionDetails['${type}']['type']['name'];
        }
        return transactionTitle;
      }else{
        String senderName;
        String companyName = '';
        String firstName = '';
        String lastName = '';
        if (resTransactionDetails.containsKey('transaction')) {
          var transactionData = resTransactionDetails['transaction'];
          if (transactionData.containsKey('customValues')) {
            var array = resTransactionDetails['transaction']['customValues'];
            for (int i = 0; i < array.length; i++) {
              var singleData = array[i];
              var val = singleData['field']['internalName'];
              if (val == 'Deposit_Sender') {
                senderName = singleData['stringValue'];
              }
              if (val == 'Beneficiary_Company_Name') {
                companyName = singleData['stringValue'];
              }
              if (val == 'Beneficiary_First_Name') {
                firstName = singleData['stringValue'];
              }
              if (val == 'Beneficiary_Last_Name') {
                lastName = singleData['stringValue'];
              }
            }
          }
        }
        if (senderName != '') {
          transactionTitle = senderName;
        }
        if (companyName != '') {
          transactionTitle = companyName;
        } else if (firstName != '' || lastName != '') {
          transactionTitle = '$firstName $lastName';
        } else if (companyName == '' || firstName == '' || lastName == '') {
          transactionTitle = resTransactionDetails['${type}']['type']['name'];
        }
      }
      print("transactionTitle ==> ${transactionTitle}");
      return transactionTitle;
    }
  }
}
