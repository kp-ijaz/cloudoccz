import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repositories/auth_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<SubmitLoginEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        final token = await authRepository.login(event.email, event.password);
        emit(LoginSuccess(event.email, token));
      } catch (e) {
        emit(LoginFailure('Login failed: $e'));
      }
    });

    on<FetchUserDetailsEvent>((event, emit) async {
      emit(UserDetailsLoading());
      try {
        final user = await authRepository.getStoredUserDetails();
        emit(UserDetailsLoaded(user));
      } catch (e) {
        emit(UserDetailsFailure('Failed to fetch user details: $e'));
      }
    });
  }
}
