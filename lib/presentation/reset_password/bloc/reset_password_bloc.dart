import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';

import '../../../data/http/model/api_error.dart';
import '../../../data/http/model/user_with_tokens_dto.dart';
import '../../../data/http/unauthorized_api_service.dart';
import '../../../data/model/request_error.dart';
import '../../registration/model/errors.dart';

part 'reset_password_event.dart';

part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  String _email = "";
  bool _highlightEmailError = false;
  RegistrationEmailError? _emailError = RegistrationEmailError.empty;
  UnauthorizedApiService unauthorizedApiService;

  ResetPasswordBloc({required this.unauthorizedApiService})
      : super(const ResetPasswordFieldInfo()) {
    on<ResetPasswordEmailChanged>(_onChangeEmail);
    on<ResetPasswordEmailFocusLost>(_onEmailFocusLost);
    on<ResetPasswordRequestErrorShowed>(_requestErrorShowed);
    on<ResetPasswordAction>(_onResetPassword);
  }

  FutureOr<void> _onChangeEmail(
    final ResetPasswordEmailChanged event,
    final Emitter<ResetPasswordState> emit,
  ) {
    _email = event.email;
    _emailError = _validateEmail();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onEmailFocusLost(
    final ResetPasswordEmailFocusLost event,
    final Emitter<ResetPasswordState> emit,
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

  FutureOr<void> _onResetPassword(
    final ResetPasswordAction event,
    final Emitter<ResetPasswordState> emit,
  ) async {
    _highlightEmailError = true;
    emit(_calculateFieldsInfo());
    final haveError = _emailError != null;

    if (haveError) {
      return;
    }
    emit(const ResetPasswordInProgress());
    final response = await resetPassword();
    if (response.isRight) {
      emit(const ResetPasswordCompletedState());
    } else {
      emit(const ResetPasswordErrorState(RequestError.unknown));
    }
  }

  Future<Either<ApiError, UserWithTokenDTO>> resetPassword() async {
    final response = await unauthorizedApiService.resetPassword(
      email: _email,
    );
    return response;
  }

  ResetPasswordFieldInfo _calculateFieldsInfo() {
    return ResetPasswordFieldInfo(
      emailError: _highlightEmailError ? _emailError : null,
    );
  }

  FutureOr<void> _requestErrorShowed(
    ResetPasswordRequestErrorShowed event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(const ResetPasswordErrorState(RequestError.noError));
  }
}
