import 'package:get_it/get_it.dart';
import 'package:gifts_manager/data/http/authorization_interceptor.dart';
import 'package:gifts_manager/data/http/authorized_api_service.dart';
import 'package:gifts_manager/data/http/dio_provider.dart';
import 'package:gifts_manager/data/http/unauthorized_api_service.dart';
import 'package:gifts_manager/data/repository/refresh_token_repository.dart';
import 'package:gifts_manager/data/repository/token_provider.dart';
import 'package:gifts_manager/data/repository/token_repository.dart';
import 'package:gifts_manager/data/repository/user_provider.dart';
import 'package:gifts_manager/data/repository/user_repository.dart';
import 'package:gifts_manager/data/storage/shared_preference_data.dart';
import 'package:gifts_manager/domain/logout_interactor.dart';
import 'package:gifts_manager/presentation/gifts/bloc/gifts_bloc.dart';
import 'package:gifts_manager/presentation/home/bloc/home_bloc.dart';
import 'package:gifts_manager/presentation/login/bloc/login_bloc.dart';
import 'package:gifts_manager/presentation/new_present/view/create_new_present.dart';
import 'package:gifts_manager/presentation/splash/bloc/splash_bloc.dart';

import '../data/repository/refresh_token_provider.dart';
import '../presentation/registration/bloc/registration_bloc.dart';
import '../presentation/reset_password/bloc/reset_password_bloc.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  _setupDataProviders();
  _setupRepositories();
  _setupInteractors();
  _setupComplexInteractors();
  _setupApiRelatedClasses();
  _setupBlocs();
}

//Only singletons
void _setupDataProviders() {
  sl.registerLazySingleton(() => SharedPreferenceData());
  sl.registerLazySingleton<RefreshTokenProvider>(
    () => sl.get<SharedPreferenceData>(),
  );
  sl.registerLazySingleton<TokenProvider>(
    () => sl.get<SharedPreferenceData>(),
  );
  sl.registerLazySingleton<UserProvider>(
    () => sl.get<SharedPreferenceData>(),
  );
}

//Only singletons
void _setupRepositories() {
  sl.registerLazySingleton(
    () => RefreshTokenRepository(sl.get<RefreshTokenProvider>()),
  );
  sl.registerLazySingleton(
    () => TokenRepository(sl.get<TokenProvider>()),
  );
  sl.registerLazySingleton(
    () => UserRepository(sl.get<UserProvider>()),
  );
}

//Only singletons
void _setupInteractors() {
  sl.registerLazySingleton(
    () => LogoutInteractor(
      userRepository: sl.get<UserRepository>(),
      tokenRepository: sl.get<TokenRepository>(),
      refreshTokenRepository: sl.get<RefreshTokenRepository>(),
    ),
  );
}

//Only singletons
void _setupComplexInteractors() {}

void _setupApiRelatedClasses() {
  sl.registerFactory(() => DioBuilder());

  sl.registerLazySingleton(
    () => AuthorizationInterceptor(
      tokenRepository: sl.get<TokenRepository>(),
      logoutInteractor: sl.get<LogoutInteractor>(),
    ),
  );

  sl.registerLazySingleton(
    () => UnauthorizedApiService(sl.get<DioBuilder>().build()),
  );

  sl.registerLazySingleton(
    () => AuthorizedApiService(sl
        .get<DioBuilder>()
        .addAuthorizationInterceptor(sl.get<AuthorizationInterceptor>())
        .build()),
  );
}

//Only factories
void _setupBlocs() {
  sl.registerFactory(
    () => LoginBloc(
      userRepository: sl.get<UserRepository>(),
      tokenRepository: sl.get<TokenRepository>(),
      refreshTokenRepository: sl.get<RefreshTokenRepository>(),
      unauthorizedApiService: sl.get<UnauthorizedApiService>(),
    ),
  );

  sl.registerFactory(
    () => RegistrationBloc(
      userRepository: sl.get<UserRepository>(),
      tokenRepository: sl.get<TokenRepository>(),
      refreshTokenRepository: sl.get<RefreshTokenRepository>(),
      unauthorizedApiService: sl.get<UnauthorizedApiService>(),
    ),
  );

  sl.registerFactory(
    () => SplashBloc(
      tokenRepository: sl.get<TokenRepository>(),
    ),
  );

  sl.registerFactory(
    () => HomeBloc(
      userRepository: sl.get<UserRepository>(),
      tokenRepository: sl.get<TokenRepository>(),
      logoutInteractor: sl.get<LogoutInteractor>(),
      authorizedApiService: sl.get<AuthorizedApiService>(),
      unauthorizedApiService: sl.get<UnauthorizedApiService>(),
      refreshTokenRepository: sl.get<RefreshTokenRepository>(),
    ),
  );

  sl.registerFactory(
    () => ResetPasswordBloc(
      unauthorizedApiService: sl.get<UnauthorizedApiService>(),
    ),
  );

  sl.registerFactory(
    () => const CreatePresentPage(),
  );

  sl.registerFactory(
    () => GiftsBloc(
      authorizedApiService: sl.get<AuthorizedApiService>(),
    ),
  );
}
