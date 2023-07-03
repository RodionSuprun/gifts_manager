import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gifts_manager/data/http/model/user_dto.dart';
import 'package:gifts_manager/data/repository/token_repository.dart';

import '../../../data/repository/user_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  final TokenRepository tokenRepository;

  HomeBloc({
    required this.userRepository,
    required this.tokenRepository,
  }) : super(HomeInitial()) {
    on<HomePageLoaded>(_onHomePageLoaded);
    on<HomeLogoutPushed>(_onHomeLogoutPushed);
  }

  FutureOr<void> _onHomePageLoaded(
    final HomePageLoaded event,
    final Emitter<HomeState> emit,
  ) async {
    final user = await userRepository.getItem();
    if (user == null) {
      _logout();
      return;
    }
    emit(HomeWithUser(user));
  }

  FutureOr<void> _onHomeLogoutPushed(
    final HomeLogoutPushed event,
    final Emitter<HomeState> emit,
  ) async {
    _logout();
    emit(const HomeLogoutState());
  }

  void _logout() async{
    await userRepository.setItem(null);
    await tokenRepository.setItem(null);
  }
}
