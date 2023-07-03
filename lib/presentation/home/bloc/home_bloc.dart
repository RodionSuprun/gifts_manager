import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gifts_manager/data/http/model/gift_dto.dart';
import 'package:gifts_manager/data/http/model/gifts_response_dto.dart';
import 'package:gifts_manager/data/http/model/user_dto.dart';
import 'package:gifts_manager/data/http/unauthorized_api_service.dart';
import 'package:gifts_manager/data/repository/refresh_token_repository.dart';
import 'package:gifts_manager/data/repository/token_repository.dart';

import '../../../data/http/authorized_api_service.dart';
import '../../../data/repository/user_repository.dart';
import '../../../domain/logout_interactor.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  final TokenRepository tokenRepository;
  final LogoutInteractor logoutInteractor;
  final AuthorizedApiService authorizedApiService;
  final UnauthorizedApiService unauthorizedApiService;
  final RefreshTokenRepository refreshTokenRepository;

  late final StreamSubscription _logoutSubscription;

  HomeBloc({
    required this.userRepository,
    required this.tokenRepository,
    required this.logoutInteractor,
    required this.authorizedApiService,
    required this.unauthorizedApiService,
    required this.refreshTokenRepository,
  }) : super(HomeInitial()) {
    on<HomePageLoaded>(_onHomePageLoaded);
    on<HomeLogoutPushed>(_onHomeLogoutPushed);
    on<HomeExternalLogout>(_onHomeExternalLogout);
    _logoutSubscription = userRepository
        .observeItem()
        .where((user) => user == null)
        .take(1)
        .listen((event) {
      _logout();
    });
  }

  FutureOr<void> _onHomePageLoaded(
    final HomePageLoaded event,
    final Emitter<HomeState> emit,
  ) async {
    final user = await userRepository.getItem();
    final token = await tokenRepository.getItem();
    final refreshToken = await refreshTokenRepository.getItem();
    if (user == null || token == null || refreshToken == null) {
      _logout();
      return;
    }

    final newTokensResponse = await unauthorizedApiService.refreshToken(refreshToken: refreshToken);
    if (newTokensResponse.isLeft) {
      _logout();
      return;
    }
    await refreshTokenRepository.setItem(newTokensResponse.right.refreshToken);
    await tokenRepository.setItem(newTokensResponse.right.token);

    final giftsResponse = await authorizedApiService.getAllGifts();

    final gifts =
        giftsResponse.isRight ? giftsResponse.right.gifts : const <GiftDTO>[];

    emit(HomeWithUserInfo(user: user, gifts: gifts));
  }

  FutureOr<void> _onHomeLogoutPushed(
    final HomeLogoutPushed event,
    final Emitter<HomeState> emit,
  ) async {
    await logoutInteractor.logout();
    _logout();
  }

  void _logout() async {
    add(const HomeExternalLogout());
  }

  FutureOr<void> _onHomeExternalLogout(
    final HomeExternalLogout event,
    final Emitter<HomeState> emit,
  ) async {
    emit(const HomeLogoutState());
  }

  @override
  Future<void> close() {
    _logoutSubscription.cancel();
    return super.close();
  }
}
