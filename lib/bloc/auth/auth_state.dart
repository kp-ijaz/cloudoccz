import 'package:cloudocz/model/user_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String email;
  final String token;

  LoginSuccess(this.email, this.token);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}

class UserDetailsLoading extends LoginState {}

class UserDetailsLoaded extends LoginState {
  final UserModel user;

  UserDetailsLoaded(this.user);
}

class UserDetailsFailure extends LoginState {
  final String error;

  UserDetailsFailure(this.error);
}
