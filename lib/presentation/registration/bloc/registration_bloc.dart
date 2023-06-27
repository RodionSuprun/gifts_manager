import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
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

  RegistrationBloc()
      : super(RegistrationFieldsInfo(
            avatarLink: _avatarBuilder(defaultAvatarKey))) {
    on<RegistrationChangeAvatar>(_onChangeAvatar);
  }

  FutureOr<void> _onChangeAvatar(
    final RegistrationChangeAvatar event,
    final Emitter<RegistrationState> emit,
  ) {
    _avatarKey = Random().nextInt(1000000).toString();
    emit(RegistrationFieldsInfo(avatarLink: _avatarBuilder(_avatarKey)));
  }
}
