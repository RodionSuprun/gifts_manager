part of 'reset_password_bloc.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();
}

class ResetPasswordFieldInfo extends ResetPasswordState {
  final RegistrationEmailError? emailError;

  const ResetPasswordFieldInfo({
    this.emailError,
  });

  @override
  List<Object?> get props => [
    emailError,
  ];
}

class ResetPasswordErrorState extends ResetPasswordState {

  final RequestError requestError;

  const ResetPasswordErrorState(this.requestError);

  @override
  List<Object?> get props => [requestError];
}

class ResetPasswordInProgress extends ResetPasswordState {

  const ResetPasswordInProgress();

  @override
  List<Object?> get props => [];
}

class ResetPasswordCompletedState extends ResetPasswordState {

  const ResetPasswordCompletedState();

  @override
  List<Object?> get props => [];
}
