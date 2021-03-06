import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fvbank/src/bloc/authentationBloc/authenticationState.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';

import 'bloc/authentationBloc/authenticationBloc.dart';
import 'bloc/authentationBloc/authenticationEvent.dart';
import 'loginEvent.dart';
import 'loginState.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null),
        super(null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginInProgress();
      try {
        var token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );
//        if(token != 'login') {
          authenticationBloc.add(AuthenticationLoggedIn(token: token));
          Map userObj = await userRepository.getUserProfile(
              sessionToken: token);
          Map accObj = await userRepository.getAccounts(sessionToken: token);
          List<dynamic> accHistoryData = await userRepository
              .getAccountsHistory(
              sessionToken: token, accountType: accObj['type']['internalName']);
          yield LoginSuccess(token: token,
              userInfor: userObj,
              accInfo: accObj,
              accHistoryData: accHistoryData);
//        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
        authenticationBloc.add(AuthenticationLoggedOut());
      }
    }
  }
}
