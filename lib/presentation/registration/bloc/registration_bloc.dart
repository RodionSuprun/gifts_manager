import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gifts_manager/data/http/model/create_account_request_dto.dart';
import 'package:gifts_manager/data/http/model/user_with_tokens_dto.dart';
import 'package:gifts_manager/data/model/request_error.dart';
import 'package:gifts_manager/data/storage/shared_preference_data.dart';
import 'package:gifts_manager/presentation/registration/model/errors.dart';
import 'package:meta/meta.dart';

part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  static const defaultAvatarKey = "test";
  static final _registrationPasswordRegexp = RegExp(r'^[a-zA-Z0-9]+$');

  static String _avatarBuilder(key) =>
      "https://api.dicebear.com/api/micah/${key}.svg";

  String _avatarKey = defaultAvatarKey;

  String _email = "";
  bool _highlightEmailError = false;
  RegistrationEmailError? _emailError = RegistrationEmailError.empty;

  String _password = "";
  bool _highlightPasswordError = false;
  RegistrationPasswordError? _passwordError = RegistrationPasswordError.empty;

  String _passwordConfirmation = "";
  bool _highlightPasswordConfirmationError = false;
  RegistrationPasswordConfirmationError? _passwordConfirmationError =
      RegistrationPasswordConfirmationError.empty;

  String _name = "";
  bool _highlightNameError = false;
  RegistrationNameError? _nameError = RegistrationNameError.empty;

  RegistrationBloc()
      : super(RegistrationFieldsInfo(
            avatarLink: _avatarBuilder(defaultAvatarKey))) {
    on<RegistrationChangeAvatar>(_onChangeAvatar);
    on<RegistrationEmailChanged>(_onChangeEmail);
    on<RegistrationEmailFocusLost>(_onEmailFocusLost);
    on<RegistrationPasswordChanged>(_onChangePassword);
    on<RegistrationPasswordFocusLost>(_onPasswordFocusLost);
    on<RegistrationPasswordConfirmationChanged>(_onChangePasswordConfirmation);
    on<RegistrationPasswordConfirmationFocusLost>(
        _onPasswordConfirmationFocusLost);
    on<RegistrationNameChanged>(_onChangeName);
    on<RegistrationNameFocusLost>(_onNameFocusLost);
    on<RegistrationCreateAccount>(_onCreateAccount);
  }

  FutureOr<void> _onCreateAccount(
    final RegistrationCreateAccount event,
    final Emitter<RegistrationState> emit,
  ) async {
    _highlightEmailError = true;
    _highlightPasswordError = true;
    _highlightPasswordConfirmationError = true;
    _highlightNameError = true;
    emit(_calculateFieldsInfo());
    final haveError = _emailError != null ||
        _passwordError != null ||
        _passwordConfirmationError != null ||
        _nameError != null;
    if (haveError) {
      return;
    }
    emit(const RegistrationInProgress());
    final token = await register();
    await SharedPreferenceData.getInstance().setToken(token);
    emit(const RegistrationCompleted());
  }

  Future<String> register() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://giftmanager.skill-branch.ru/api",
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }

    final requestBody = CreateAccountRequestDTO(
      email: _email,
      name: _name,
      password: _password,
      avatarUrl: _avatarBuilder(_avatarKey),
    );

    try {
      final response = await dio.post(
        "/auth/create",
        data: requestBody.toJson(),
      );

      final userWithTokens = UserWithTokenDTO.fromJson(response.data);

      return userWithTokens.token;
    } catch (e) {}

    return "token";
  }

  FutureOr<void> _onChangeAvatar(
    final RegistrationChangeAvatar event,
    final Emitter<RegistrationState> emit,
  ) {
    _avatarKey = Random().nextInt(1000000).toString();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onChangeEmail(
    final RegistrationEmailChanged event,
    final Emitter<RegistrationState> emit,
  ) {
    _email = event.email;
    _emailError = _validateEmail();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onEmailFocusLost(
    final RegistrationEmailFocusLost event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightEmailError = true;
    emit(_calculateFieldsInfo());
  }

  RegistrationEmailError? _validateEmail() {
    if (_email.isEmpty) {
      return RegistrationEmailError.empty;
    }
    if (!EmailValidator.validate(_email)) {
      return RegistrationEmailError.invalid;
    }
    return null;
  }

  FutureOr<void> _onChangePassword(
    final RegistrationPasswordChanged event,
    final Emitter<RegistrationState> emit,
  ) {
    _password = event.password;
    _passwordError = _validatePassword();
    _passwordConfirmationError = _validatePasswordConfirmation();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onPasswordFocusLost(
    final RegistrationPasswordFocusLost event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightPasswordError = true;
    emit(_calculateFieldsInfo());
  }

  RegistrationPasswordError? _validatePassword() {
    if (_password.isEmpty) {
      return RegistrationPasswordError.empty;
    }
    if (_password.length < 6) {
      return RegistrationPasswordError.tooShort;
    }
    if (!_registrationPasswordRegexp.hasMatch(_password)) {
      return RegistrationPasswordError.wrongSymbols;
    }
    return null;
  }

  FutureOr<void> _onChangePasswordConfirmation(
    final RegistrationPasswordConfirmationChanged event,
    final Emitter<RegistrationState> emit,
  ) {
    _passwordConfirmation = event.passwordConfirmation;
    _passwordConfirmationError = _validatePasswordConfirmation();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onPasswordConfirmationFocusLost(
    final RegistrationPasswordConfirmationFocusLost event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightPasswordConfirmationError = true;
    emit(_calculateFieldsInfo());
  }

  RegistrationPasswordConfirmationError? _validatePasswordConfirmation() {
    if (_passwordConfirmation.isEmpty) {
      return RegistrationPasswordConfirmationError.empty;
    }
    if (_passwordConfirmation != _password) {
      return RegistrationPasswordConfirmationError.different;
    }
    return null;
  }

  FutureOr<void> _onChangeName(
    final RegistrationNameChanged event,
    final Emitter<RegistrationState> emit,
  ) {
    _name = event.name;
    _nameError = _validateName();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onNameFocusLost(
    final RegistrationNameFocusLost event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightNameError = true;
    emit(_calculateFieldsInfo());
  }

  RegistrationNameError? _validateName() {
    if (_name.isEmpty) {
      return RegistrationNameError.empty;
    }
    return null;
  }

  RegistrationFieldsInfo _calculateFieldsInfo() {
    return RegistrationFieldsInfo(
      avatarLink: _avatarBuilder(_avatarKey),
      emailError: _highlightEmailError ? _emailError : null,
      passwordError: _highlightPasswordError ? _passwordError : null,
      passwordConfirmationError: _highlightPasswordConfirmationError
          ? _passwordConfirmationError
          : null,
      nameError: _highlightNameError ? _nameError : null,
    );
  }
}
