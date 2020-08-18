import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';



abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSuccess extends LoginState {
  final Map userInfor;
  final Map accInfo;
  final List<dynamic> accHistoryData;

  const LoginSuccess({@required this.userInfor,@required this.accInfo, @required this.accHistoryData});

  @override
  List<Object> get props => [userInfor,accInfo,accHistoryData];

  @override
  String toString() => 'LoginUserInfor { userInfor: $userInfor }';
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}
