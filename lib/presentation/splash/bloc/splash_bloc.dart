import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gifts_manager/data/storage/shared_preference_data.dart';

import '../../../data/repository/token_repository.dart';
import '../../../di/service_locator.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashLoaded>(_onSplashLoaded);
  }

  FutureOr<void> _onSplashLoaded(
    final SplashLoaded event,
    final Emitter<SplashState> emit,
  ) async {
    final token = await sl.get<TokenRepository>().getItem();
    if (token == null || token.isEmpty) {
      emit(const SplashUnauthorized());
    } else {
      emit(const SplashAuthorized());
    }
  }
}
