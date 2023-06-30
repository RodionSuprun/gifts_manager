part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();
}

class ResetPasswordEmailChanged extends ResetPasswordEvent {
  final String email;

  const ResetPasswordEmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetPasswordEmailFocusLost extends ResetPasswordEvent {
  const ResetPasswordEmailFocusLost();

  @override
  List<Object?> get props => [];
}

class ResetPasswordAction extends ResetPasswordEvent {
  const ResetPasswordAction();

  @override
  List<Object?> get props => [];
}

class ResetPasswordRequestErrorShowed extends ResetPasswordEvent {
  const ResetPasswordRequestErrorShowed();

  @override
  List<Object?> get props => [];
}





