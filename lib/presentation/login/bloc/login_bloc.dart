import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';

import '../../../data/model/request_error.dart';
import '../model/models.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<LoginLoginButtonClicked>(_loginButtonClicked);
    on<LoginEmailChanged>(_emailChanged);
    on<LoginPasswordChanged>(_passwordChanged);
    on<LoginRequestErrorShowed>(_requestErrorShowed);
  }

  static final _passwordRegexp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  FutureOr<void> _loginButtonClicked(
    LoginLoginButtonClicked event,
    Emitter<LoginState> emit,
  ) async {
    if (state.allFieldsValid) {
      final response =
          await _login(email: state.email, password: state.password);
      if (response == null) {
        emit(state.copyWith(authenticated: true));
      } else {
        switch (response) {
          case LoginError.emailNotExist:
            emit(state.copyWith(emailError: EmailError.notExist));
            break;
          case LoginError.wrongPassword:
            emit(state.copyWith(passwordError: PasswordError.wrongPassword));
            break;
          case LoginError.other:
            emit(state.copyWith(requestError: RequestError.unknown));
            break;
        }
      }
    }
  }

  Future<LoginError?> _login({
    required final String email,
    required final String password,
  }) async {
    final successfulResponse = Random().nextBool();
    if (successfulResponse) {
      return null;
    }
    return LoginError.values[Random().nextInt(LoginError.values.length)];
  }

  FutureOr<void> _emailChanged(
      LoginEmailChanged event, Emitter<LoginState> emit) {
    final newEmail = event.email;
    final emailValid = _emailValid(newEmail);
    emit(state.copyWith(
      email: newEmail,
      emailValid: emailValid,
      authenticated: false,
      emailError: EmailError.noError,
    ));
  }

  bool _emailValid(final String email) {
    return EmailValidator.validate(email);
  }

  FutureOr<void> _passwordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final newPassword = event.password;
    final passwordValid = _passwordValid(newPassword);
    emit(state.copyWith(
      password: newPassword,
      passwordValid: passwordValid,
      authenticated: false,
      passwordError: PasswordError.noError,
    ));
  }

  bool _passwordValid(final String password) {
    return _passwordRegexp.hasMatch(password);
  }

  FutureOr<void> _requestErrorShowed(
      LoginRequestErrorShowed event, Emitter<LoginState> emit) {
    emit(state.copyWith(requestError: RequestError.noError));
  }

  @override
  void onEvent(LoginEvent event) {
    print("onEvent: $event");
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    print("onTransition: $transition");
    super.onTransition(transition);
  }
}

enum LoginError { emailNotExist, wrongPassword, other }
