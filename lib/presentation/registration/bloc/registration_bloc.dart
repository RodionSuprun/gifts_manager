import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:gifts_manager/data/model/request_error.dart';
import 'package:gifts_manager/presentation/registration/model/errors.dart';
import 'package:meta/meta.dart';

part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  static const defaultAvatarKey = "test";

  static String _avatarBuilder(key) =>
      "https://api.dicebear.com/api/micah/${key}.svg";

  String _avatarKey = defaultAvatarKey;

  String _email = "";
  bool _highlightEmailError = false;
  RegistrationEmailError? _emailError;

  String _password = "";
  bool _highlightPasswordError = false;
  RegistrationPasswordError? _passwordError;

  String _passwordConfirmation = "";
  bool _highlightPasswordConfirmationError = false;
  RegistrationPasswordConfirmationError? _passwordConfirmationError;

  String _name = "";
  bool _highlightNameError = false;
  RegistrationNameError? _nameError;

  RegistrationBloc()
      : super(RegistrationFieldsInfo(
            avatarLink: _avatarBuilder(defaultAvatarKey))) {
    on<RegistrationChangeAvatar>(_onChangeAvatar);
    on<RegistrationEmailChanged>(_onChangeEmail);
    on<RegistrationEmailFocusLost>(_onEmailFocusLost);
    on<RegistrationCreateAccount>(_onCreateAccount);
  }

  FutureOr<void> _onCreateAccount(
      final RegistrationCreateAccount event,
      final Emitter<RegistrationState> emit,
      ) {
    _highlightEmailError = true;
    _highlightPasswordError = true;
    _highlightPasswordConfirmationError = true;
    _highlightNameError = true;
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onEmailFocusLost(
    final RegistrationEmailFocusLost event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightEmailError = true;
    emit(_calculateFieldsInfo());
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

  RegistrationFieldsInfo _calculateFieldsInfo() {
    return RegistrationFieldsInfo(
      avatarLink: _avatarBuilder(_avatarKey),
      emailError: _highlightEmailError ? _emailError : null,
      passwordError: _passwordError,
    );
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
}
