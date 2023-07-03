import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:gifts_manager/data/http/api_error_type.dart';
import 'package:gifts_manager/data/http/model/api_error.dart';
import 'package:gifts_manager/data/http/unauthorized_api_service.dart';

import '../../../data/http/model/user_with_tokens_dto.dart';
import '../../../data/model/request_error.dart';
import '../../../data/repository/refresh_token_repository.dart';
import '../../../data/repository/token_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../model/models.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final TokenRepository tokenRepository;
  final RefreshTokenRepository refreshTokenRepository;
  final UnauthorizedApiService unauthorizedApiService;

  LoginBloc({
    required this.userRepository,
    required this.tokenRepository,
    required this.refreshTokenRepository,
    required this.unauthorizedApiService,
  }) : super(LoginState.initial()) {
    on<LoginLoginButtonClicked>(_loginButtonClicked);
    on<LoginEmailChanged>(_emailChanged);
    on<LoginPasswordChanged>(_passwordChanged);
    on<LoginRequestErrorShowed>(_requestErrorShowed);
    on<LoginAfterResetPassword>(_afterResetPassword);
  }

  // static final _passwordRegexp =
  //     RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  FutureOr<void> _loginButtonClicked(
    LoginLoginButtonClicked event,
    Emitter<LoginState> emit,
  ) async {
    if (state.allFieldsValid) {
      final response =
          await _login(email: state.email, password: state.password);
      if (response.isRight) {
        final userWithTokens = response.right;
        await userRepository.setItem(userWithTokens.user);
        await tokenRepository.setItem(userWithTokens.token);
        await refreshTokenRepository.setItem(userWithTokens.refreshToken);
        emit(state.copyWith(authenticated: true));
      } else {
        final apiError = response.left;
        switch (apiError.errorType) {
          case ApiErrorType.incorrectPassword:
            emit(state.copyWith(passwordError: PasswordError.wrongPassword));
            break;
          case ApiErrorType.notFound:
            emit(state.copyWith(emailError: EmailError.notExist));
            break;
          default:
            emit(state.copyWith(requestError: RequestError.unknown));
            break;
        }
      }
    }
  }

  Future<Either<ApiError, UserWithTokenDTO>> _login({
    required final String email,
    required final String password,
  }) async {
    final response = await unauthorizedApiService.login(
      email: email,
      password: password,
    );
    return response;
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
    return password.length > 5;
  }

  FutureOr<void> _requestErrorShowed(
      LoginRequestErrorShowed event, Emitter<LoginState> emit) {
    emit(state.copyWith(requestError: RequestError.noError));
    emit(state.copyWith(showAfterPassword: false));
  }

  FutureOr<void> _afterResetPassword(
      LoginAfterResetPassword event, Emitter<LoginState> emit) {
    emit(state.copyWith(showAfterPassword: true));
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
