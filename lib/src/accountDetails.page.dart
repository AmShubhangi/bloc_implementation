import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fvbank/src/loginBloc.dart';
import 'package:fvbank/src/loginState.dart';
import 'package:fvbank/src/menu.page.dart';
import 'package:fvbank/themes/common.theme.dart';

class AccountDetailsPage extends StatelessWidget {
  final PageRouteBuilder _homeRoute = new PageRouteBuilder(
    pageBuilder: (BuildContext context, _, __) {
      return MenuPage();
    },
  );

  dynamic rowItem(context, String label, String value) {
    return Container(
      padding: EdgeInsets.only(top: 4, right: 16, left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 4),
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: CommonTheme.TEXT_SIZE_SMALL,
                fontFamily: CommonTheme.FONT_LIGHT,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
//              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: CommonTheme.TEXT_SIZE_SMALL,
                fontFamily: CommonTheme.FONT_MEDIUM,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  dynamic addressRowItem(context, String label, String value) {
    return Container(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              label,
              style: TextStyle(
                fontSize: CommonTheme.TEXT_SIZE_SMALL,
                fontFamily: CommonTheme.FONT_MEDIUM,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: CommonTheme.TEXT_SIZE_SMALL,
                fontFamily: CommonTheme.FONT_LIGHT,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginSuccess) {
              String nationality = '';
              String purposeOfAccount = '';
              String depositInstruction = '';
              String depositReferenceNumber = '';
              var array = state.userInfor['customValues'];
              for (int i = 0; i < array.length; i++) {
                var singleData = array[i];
                var val = singleData['field']['internalName'];
                if (val == 'Individual_Nationality') {
                  nationality = singleData['enumeratedValues'][0]['value'];
                }
                if (val == 'Purpose_Account') {
                  purposeOfAccount = singleData['enumeratedValues'][0]['value'];
                }
                if (val == 'Metro_Details_Depsoit') {
                  depositInstruction = singleData['stringValue'];
                }
                if (val == 'Metro_Account_USD') {
                  depositReferenceNumber = singleData['stringValue'];
                }
              }
              return SafeArea(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              height: 32,
                              width: 32,
                              child: FlatButton(
//                              onPressed: () => Navigator.pop(context),
                                onPressed: () => Navigator.pushAndRemoveUntil(
                                    context,
                                    _homeRoute,
                                    (Route<dynamic> r) => false),
                                padding: EdgeInsets.all(0),
                                child: Image.asset(
                                  'images/icon_nav_back_arrow_dark.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 96,
                              child: Text(
                                'Account Details',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: CommonTheme.TEXT_SIZE_LARGE,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 24,
                        thickness: 1,
                        color: Colors.grey,
                      ),
//                      rowItem(
//                          context, 'Group', state.userInfor['group']['name']),
                      rowItem(context, 'Full Name', state.userInfor['display']),
                      rowItem(context, 'Login Name',
                          state.userInfor['shortDisplay']),
                      rowItem(context, 'Email', state.userInfor['email']),
                      rowItem(context, 'Mobile Phone',
                          state.userInfor['phones'][0]['number']),
                      rowItem(context, 'Nationality', nationality),
                      rowItem(context, 'Purpose Of Account', purposeOfAccount),
                      rowItem(
                          context, 'Deposit instruction', depositInstruction),
                      rowItem(context, 'Deposit Reference Number',
                          depositReferenceNumber),
                      Divider(
                        height: 24,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Address',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: CommonTheme.TEXT_SIZE_DEFAULT,
                                fontWeight: FontWeight.bold,
                                color: CommonTheme.COLOR_PRIMARY,
                              ),
                            ),
                            Text(
                              state.userInfor['addresses'][0]['street'] +
                                  ', ' +
                                  state.userInfor['addresses'][0]
                                      ['buildingNumber'],
                              style: TextStyle(
                                fontSize: CommonTheme.TEXT_SIZE_DEFAULT,
                                color: Colors.grey[600],
                              ),
                            ),
                            addressRowItem(context, 'Postal Code: ',
                                state.userInfor['addresses'][0]['zip']),
                            addressRowItem(context, 'City: ',
                                state.userInfor['addresses'][0]['city']),
                            addressRowItem(context, 'Region / state: ',
                                state.userInfor['addresses'][0]['region']),
                            addressRowItem(context, 'Country: ',
                                state.userInfor['addresses'][0]['country']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
