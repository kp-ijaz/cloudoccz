abstract class LoginEvent {}

class SubmitLoginEvent extends LoginEvent {
  final String email;
  final String password;

  SubmitLoginEvent(this.email, this.password);
}

class FetchUserDetailsEvent extends LoginEvent {
  final String token;

  FetchUserDetailsEvent(this.token);
}
