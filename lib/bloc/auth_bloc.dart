import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

// Events
abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({required this.username, required this.password});
}

// States
abstract class LoginState {}

class InitialLoginState extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String accessToken;

  LoginSuccess({required this.accessToken});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(InitialLoginState());

  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final url = Uri.parse(
            // 'http://203.91.116.148/api/auth/get_tokens?username=${event.username}&password=${event.password}');
            'http://203.91.116.148/api/auth/get_tokens?username=galbadrakh@abico.mn&password=Galbadrakh1!');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          final accessToken = responseBody['access_token'];
          yield LoginSuccess(accessToken: accessToken);
        } else {
          yield LoginFailure(error: 'Failed to log in');
        }
      } catch (e) {
        yield LoginFailure(error: 'An error occurred');
      }
    }
  }
}
