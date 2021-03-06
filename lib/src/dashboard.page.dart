import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fvbank/src/commonFunc.dart';
import 'package:fvbank/src/login.page.dart';
import 'package:fvbank/src/loginBloc.dart';
import 'package:fvbank/src/loginState.dart';
import 'package:fvbank/themes/common.theme.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart';

import 'component/transactionDetail.component.dart';
import 'component/transactionItem.component.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  bool isLoading = false;
  var resTransactionDetails;
  UserRepository userRepository;
  var storage = FlutterSecureStorage();
  var transTitle = "";
  String senderName;
  String companyName = '';
  String firstName = '';
  String lastName = '';
  TransactionSection transactionSection;

  @override
  void initState() {
    super.initState();
    this.userRepository = new UserRepository();
    this.transactionSection = new TransactionSection();
  }

  handleAPIError(dynamic res) {
    setState(() {
      isLoading = false;
    });
    if (res['code'] == 'loggedOut') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(
              userRepository: userRepository,
            )),
      );
      return;
    }
  }

  _transactionItemPressed(
      context, int index, dynamic data, String token) async {
    dynamic transactionNumber = data[index]['transactionNumber'];

    dynamic resTransactionDetails =
    await TransactionSection.getTransactionDetail(token, transactionNumber);

    String to = '';
    String from = '';
    var transactionData = resTransactionDetails.containsKey('transaction')
        ? resTransactionDetails['transaction']
        : [];
    bool isTrue = resTransactionDetails.containsKey('transaction')
        ? transactionData.containsKey('customValues')
        : false;
    if (resTransactionDetails['from']['kind'] == 'user') {
      var transactionTitle = resTransactionDetails['to']['type']['name'];
      if (resTransactionDetails['kind'] == 'payment') {
        if (isTrue) {
          resTransactionDetails['transaction']['customValues'].map((i) =>
          i['field']['internalName'] == 'Beneficiary_Company_Name'
              ? (companyName = i['stringValue'])
              : (companyName = transactionTitle));

          resTransactionDetails['transaction']['customValues'].map((i) =>
          i['field']['internalName'] == 'Beneficiary_First_Name'
              ? (firstName = i['stringValue'])
              : (firstName = transactionTitle));

          resTransactionDetails['transaction']['customValues'].map((i) =>
          i['field']['internalName'] == 'Beneficiary_Last_Name'
              ? (lastName = i['stringValue'])
              : (lastName = transactionTitle));
        }
        (companyName != '')
            ? transactionTitle = companyName
            : (firstName != '' || lastName != '')
            ? transactionTitle = '$firstName $lastName'
            : (companyName == '' || firstName == '' || lastName == '')
            ? transactionTitle =
        resTransactionDetails['to']['type']['name']
        // ignore: unnecessary_statements
            : transactionTitle;
      } else if (resTransactionDetails['kind'] == 'transferFee') {}
      if (transactionTitle != '') {
        to = transactionTitle;
        from = resTransactionDetails['from']['user']['display'];
      }
    } else {
      var transactionTitle = resTransactionDetails['from']['type']['name'];
      if (isTrue) {
        resTransactionDetails['transaction']['customValues'].map((i) =>
        i['field']['internalName'] == 'Deposit_Sender'
            ? (senderName = i['stringValue'])
            : (senderName = transactionTitle));

        resTransactionDetails['transaction']['customValues'].map((i) =>
        i['field']['internalName'] == 'Beneficiary_Company_Name'
            ? (companyName = i['stringValue'])
            : (companyName = transactionTitle));

        resTransactionDetails['transaction']['customValues'].map((i) =>
        i['field']['internalName'] == 'Beneficiary_First_Name'
            ? (firstName = i['stringValue'])
            : (firstName = transactionTitle));

        resTransactionDetails['transaction']['customValues'].map((i) =>
        i['field']['internalName'] == 'Beneficiary_Last_Name'
            ? (lastName = i['stringValue'])
            : (lastName = transactionTitle));
      }

      // ignore: unnecessary_statements
      (companyName != '')
          ? transactionTitle = companyName
          : (firstName != '' || lastName != '')
          ? transactionTitle = '$firstName $lastName'
          : (companyName == '' || firstName == '' || lastName == '')
          ? transactionTitle =
      resTransactionDetails['from']['type']['name']
          : (senderName != '')
          ? transactionTitle = senderName
          : transactionTitle;

      if (transactionTitle != '') {
        to = resTransactionDetails['to']['user']['display'];
        from = transactionTitle;
      }
    }

    String performedBy = resTransactionDetails.containsKey('transaction')
        ? resTransactionDetails['transaction']['by']['display']
        : '';
    String channel = resTransactionDetails.containsKey('transaction')
        ? resTransactionDetails['transaction']['channel']['name']
        : '';
    String description = resTransactionDetails['transaction']['description'];

    dynamic typeName = data[index]['type'];
    DateTime date = DateTime.parse(data[index]['date']);
    var tDate = new DateFormat('MM-dd-yyyy hh:mm a').format(date);
    setState(() {
      isLoading = false;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return TransactionDetailComponent(
            transactionNumber: transactionNumber,
            date: tDate,
            amount: data[index]['amount'],
            performedBy: performedBy,
            from: from,
            to: to,
            paymentType: typeName['name'],
            channel: channel,
            description: description == null ? '' : description,
          );
        });
  }

  Future<dynamic> _getName(
      context, int index, dynamic data, String token) async {
    dynamic resTransactionDetails =
    await TransactionSection.getTransactionDetail(
        token, data[index]['transactionNumber']);
    var transactionData = resTransactionDetails.containsKey('transaction')
        ? resTransactionDetails['transaction']
        : '';
    bool isTrue = resTransactionDetails.containsKey('transaction')
        ? transactionData.containsKey('customValues')
        : false;
    String transactionTitle = '';
    if (resTransactionDetails['from']['kind'] == 'user') {
      transactionTitle = resTransactionDetails['to']['type']['name'];
      if (resTransactionDetails['kind'] == 'payment') {
        if (isTrue) {
          resTransactionDetails['transaction']['customValues'].map((i) =>
          i['field']['internalName'] == 'Beneficiary_Company_Name'
              ? (companyName = i['stringValue'])
              : (companyName = transactionTitle));

          resTransactionDetails['transaction']['customValues'].map((i) =>
          i['field']['internalName'] == 'Beneficiary_First_Name'
              ? (firstName = i['stringValue'])
              : (firstName = transactionTitle));

          resTransactionDetails['transaction']['customValues'].map((i) =>
          i['field']['internalName'] == 'Beneficiary_Last_Name'
              ? (lastName = i['stringValue'])
              : (lastName = transactionTitle));
        }
        (companyName != '')
            ? transactionTitle = companyName
            : (firstName != '' || lastName != '')
            ? transactionTitle = '$firstName $lastName'
            : (companyName == '' || firstName == '' || lastName == '')
            ? transactionTitle =
        resTransactionDetails['to']['type']['name']
        // ignore: unnecessary_statements
            : transactionTitle;
      } else if (resTransactionDetails['kind'] == 'transferFee') {}
    } else {
      if (isTrue) {
        resTransactionDetails['transaction']['customValues'].map((i) =>
        i['field']['internalName'] == 'Deposit_Sender'
            ? (senderName = i['stringValue'])
            : (senderName = transactionTitle));

        resTransactionDetails['transaction']['customValues'].map((i) =>
        i['field']['internalName'] == 'Beneficiary_Company_Name'
            ? (companyName = i['stringValue'])
            : (companyName = transactionTitle));

        resTransactionDetails['transaction']['customValues'].map((i) =>
        i['field']['internalName'] == 'Beneficiary_First_Name'
            ? (firstName = i['stringValue'])
            : (firstName = transactionTitle));

        resTransactionDetails['transaction']['customValues'].map((i) =>
        i['field']['internalName'] == 'Beneficiary_Last_Name'
            ? (lastName = i['stringValue'])
            : (lastName = transactionTitle));
      }
      (companyName != '')
          ? transactionTitle = companyName
          : (firstName != '' || lastName != '')
          ? transactionTitle = '$firstName $lastName'
          : (companyName == '' || firstName == '' || lastName == '')
          ? transactionTitle =
      resTransactionDetails['from']['type']['name']
          : (senderName != '')
          ? transactionTitle = senderName
      // ignore: unnecessary_statements
          : transactionTitle;
    }
    return transactionTitle;
  }

  dynamic _listItem(List<dynamic> historyListData, String token) {
    if (historyListData.length > 0 || historyListData != null) {
      return Container(
        child: ListView.separated(
            shrinkWrap: true,
            itemCount: historyListData.length,
            itemBuilder: (BuildContext context, int index) {
              DateTime date = DateTime.parse(historyListData[index]['date']);
              final DateFormat formatter = DateFormat('MM-dd-yyyy hh:mm a');
              final String formattedDate = formatter.format(date);
              return GestureDetector(
                child: IntrinsicHeight(
                  child: FutureBuilder<dynamic>(
                      future: _getName(context, index, historyListData, token),
                      builder: (context, snapshot) {
                        return TransactionItemComponent(
                          companyName: snapshot.hasData ? snapshot.data : '--',
                          dateTime: formattedDate,
                          amount: historyListData[index]['amount'],
                          transactionId: historyListData[index]
                          ['transactionNumber'],
                          description: historyListData[index]['description'],
                          imagePath: 'images/icon_bank.png',
                        );
                      }),
                ),
                onTap: () {
                  print('Item Selected:-$index');
                  setState(() {
                    isLoading = true;
                  });
                  _transactionItemPressed(
                      context, index, historyListData, token);
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            )),
      );
    } else {
      return Container(
        color: CommonTheme.COLOR_BRIGHT,
        //width: MediaQuery.of(context).size.width,
        child: Text(
          'Loading',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = isLoading
        ? new Container(
      color: Colors.black.withOpacity(0.3),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: new Padding(
        padding: const EdgeInsets.all(5.0),
        child: new Center(
          child: new CircularProgressIndicator(),
        ),
      ),
    )
        : new Container(width: 0.0, height: 0.0);
    return MaterialApp(
      home: Scaffold(
          backgroundColor: CommonTheme.COLOR_PRIMARY,
          body: Scaffold(
            backgroundColor: CommonTheme.COLOR_PRIMARY,
            body: Container(
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginSuccess) {
                    return Stack(
                      children: <Widget>[
                        SafeArea(
                          bottom: false,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      state.userInfor['display'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: CommonTheme.TEXT_SIZE_MEDIUM,
                                      ),
                                    ),
//                                    Text(
//                                      state.userInfor != null
//                                          ? state.userInfor['group']['name'] +
//                                              ' Account'
//                                          : '--',
//                                      style: TextStyle(
//                                        color: Colors.white,
//                                        fontSize: CommonTheme.TEXT_SIZE_SMALL,
//                                      ),
//                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 27),
                                      child: Text(
                                        'Current Balance',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: CommonTheme.TEXT_SIZE_SMALL,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 16),
                                      child: Text(
                                        state.accInfo['currency']['symbol'] +
                                            ' ' +
                                            state.accInfo['status']
                                            ['availableBalance'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: CommonTheme
                                                .TEXT_SIZE_EXTRA_LARGE,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: _listItem(
                                    state.accHistoryData, state.token),
                              ),
                            ],
                          ),
                        ),
                        new Align(
                          child: loadingIndicator,
                          alignment: FractionalOffset.center,
                        ),
                      ],
                    );
                  } else if (state is LoginFailure) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
//                  handleAPIError(state.error);
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  );
                },
              ),
            ),
          )),
    );
  }
}
