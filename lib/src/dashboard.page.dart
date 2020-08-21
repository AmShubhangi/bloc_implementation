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
  UserRepository userRepository;
  var storage = FlutterSecureStorage();
  var transTitle = "";
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
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      return;
    }
  }

  _transactionItemPressed(context, int index, dynamic data) async {
    dynamic transactionNumber = data[index]['transactionNumber'];
    var resTransactionDetails = await userRepository.getTransactionDetail(
        sessionToken: await storage.read(key: "authToken"),
        transactionNumber: transactionNumber);

    String to = '';
    String from = '';
    if (resTransactionDetails['from']['kind'] == 'user') {
      var transactionTitle = resTransactionDetails['to']['type']['name'];
      if (resTransactionDetails['kind'] == 'payment') {
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
          transactionTitle = resTransactionDetails['to']['type']['name'];
        }
      } else if (resTransactionDetails['kind'] == 'transferFee') {}
      if (transactionTitle != '') {
        to = transactionTitle;
        from = resTransactionDetails['from']['user']['display'];
      }
    } else {
      var transactionTitle = resTransactionDetails['from']['type']['name'];

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
        transactionTitle = resTransactionDetails['from']['type']['name'];
      }

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
    final DateFormat formatter = DateFormat('MM-dd-yyyy hh:mm a');
    final String formattedDate = formatter.format(date);
    setState(() {
      isLoading = false;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return TransactionDetailComponent(
            transactionNumber: transactionNumber,
            date: formattedDate,
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

  Future<String> _getName(context, int index, dynamic data) async {



//    if (this.props.transactionDetails.from.kind === 'user') {
//      let transactionTitle = this.props.transactionDetails.to.type.name;
//      if (this.props.transactionDetails.kind === 'payment') {
//        const companyName = this.props.transactionDetails.transaction?.customValues?.find(data => data.field.internalName === 'Beneficiary_Company_Name')?.stringValue;
//        const firstName = this.props.transactionDetails.transaction?.customValues?.find(data => data.field.internalName === 'Beneficiary_First_Name')?.stringValue;
//        const lastName = this.props.transactionDetails.transaction?.customValues?.find(data => data.field.internalName === 'Beneficiary_Last_Name')?.stringValue;
//
//        if (!!companyName) {
//          transactionTitle = companyName;
//        } else if (firstName || lastName) {
//          transactionTitle = `${firstName} ${lastName}`;
//    }
//    } else if (this.props.transactionDetails.kind === 'transferFee') {
//
//    }
//    if (!!transactionTitle) {
//    to = transactionTitle;
//    from = this.props.transactionDetails.from.user.display;
//    }
//    } else {
//    let transactionTitle = this.props.transactionDetails.from.type.name;
//    const senderName = this.props.transactionDetails.transaction?.customValues?.find(data => data.field.internalName === 'Deposit_Sender')?.stringValue;
//    if (senderName) {
//    transactionTitle = senderName;
//    }
//    const companyName = this.props.transactionDetails.transaction?.customValues?.find(data => data.field.internalName === 'Beneficiary_Company_Name')?.stringValue;
//    const firstName = this.props.transactionDetails.transaction?.customValues?.find(data => data.field.internalName === 'Beneficiary_First_Name')?.stringValue;
//    const lastName = this.props.transactionDetails.transaction?.customValues?.find(data => data.field.internalName === 'Beneficiary_Last_Name')?.stringValue;
//
//    if (!!companyName) {
//    transactionTitle = companyName;
//    } else if (firstName || lastName) {
//    transactionTitle = `${firstName} ${lastName}`;
//    }
//
//    if (!!transactionTitle) {
//    to = this.props.transactionDetails.to.user.display;
//    from = transactionTitle;
//    }
//    }
//
//
//
//








    var resTransactionDetails = await userRepository.getTransactionDetail(
        sessionToken: await storage.read(key: "authToken"),
        transactionNumber: data[index]['transactionNumber']);
    String companyName = '';
    String firstName = '';
    String lastName = '';
    String transactionTitle = '';
    var companyNameXYZ = .find((data) => data.stringValue;
    var companyNameXYZ = resTransactionDetails ? resTransactionDetails['transaction'] : resTransactionDetails['transaction']['customValues']  ? [];
     companyNameXYZ.fold(0,((prev ,next)=>{print("prevvv $prev +==== ${next['field']['internalName'] == 'Beneficiary_Company_Name'}")}));
    print('CompanyName ==>> $companyNameXYZ');
    if (resTransactionDetails['from']['kind'] == 'user') {
      print("If");
//      transactionSection.TransactionName("to", resTransactionDetails,
//          resTransactionDetails['to']['type']['name']);
      transactionTitle = resTransactionDetails['to']['type']['name'];
      if (resTransactionDetails['kind'] == 'payment') {
        if (resTransactionDetails.containsKey('transaction')) {
          var transactionData = resTransactionDetails['transaction'];
          if (transactionData.containsKey('customValues')) {
//    var companyNameXYZ = resTransactionDetails['transaction']['customValues'].find((data) => data['field']['internalName'] == 'Beneficiary_Company_Name').stringValue;
//    print('CompanyName ==>> $companyNameXYZ');
//        .transaction?.customValues?.find(data => data.field.internalName === 'Beneficiary_Company_Name')?.stringValue;
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
          transactionTitle = resTransactionDetails['to']['type']['name'];
        }
      } else if (resTransactionDetails['kind'] == 'transferFee') {}
    } else {
      print("else");
//      transactionSection.TransactionName("from", resTransactionDetails,
//          resTransactionDetails['from']['type']['name']);

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
        transactionTitle = resTransactionDetails['from']['type']['name'];
      }
    }
    return transactionTitle;
  }

  dynamic _listItem(List<dynamic> historyListData) {
    if (historyListData.length > 0 || historyListData != null) {
      return Container(
        child: ListView.separated(
            shrinkWrap: true,
            itemCount: historyListData.length,
            itemBuilder: (BuildContext context, int index) {
              dynamic typeName = historyListData[index]['type'];
              DateTime date = DateTime.parse(historyListData[index]['date']);
              final DateFormat formatter = DateFormat('MM-dd-yyyy hh:mm a');
              final String formattedDate = formatter.format(date);
              return GestureDetector(
                child: IntrinsicHeight(
                  child: FutureBuilder<String>(
                      future: _getName(context, index, historyListData),
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
                  _transactionItemPressed(context, index, historyListData);
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
//                    print('Dashboard Name ==>> ${state.userInfor['group']['name']}');
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
                                child: _listItem(state.accHistoryData),
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
