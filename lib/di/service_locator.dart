import 'package:get_it/get_it.dart';
import 'package:gifts_manager/data/http/dio_provider.dart';
import 'package:gifts_manager/data/repository/refresh_token_repository.dart';
import 'package:gifts_manager/data/repository/token_provider.dart';
import 'package:gifts_manager/data/repository/token_repository.dart';
import 'package:gifts_manager/data/repository/user_provider.dart';
import 'package:gifts_manager/data/repository/user_repository.dart';
import 'package:gifts_manager/data/storage/shared_preference_data.dart';
import 'package:gifts_manager/presentation/login/bloc/login_bloc.dart';
import 'package:gifts_manager/presentation/splash/bloc/splash_bloc.dart';

import '../data/repository/refresh_token_provider.dart';
import '../presentation/registration/bloc/registration_bloc.dart';

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
  sl.registerLazySingleton(() => DioProvider());
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
void _setupInteractors() {}

//Only singletons
void _setupComplexInteractors() {}

//Only singletons
void _setupApiRelatedClasses() {}

//Only factories
void _setupBlocs() {
  sl.registerFactory(
    () => LoginBloc(
      userRepository: sl.get<UserRepository>(),
      tokenRepository: sl.get<TokenRepository>(),
      refreshTokenRepository: sl.get<RefreshTokenRepository>(),
    ),
  );

  sl.registerFactory(
    () => RegistrationBloc(
      userRepository: sl.get<UserRepository>(),
      tokenRepository: sl.get<TokenRepository>(),
      refreshTokenRepository: sl.get<RefreshTokenRepository>(),
    ),
  );

  sl.registerFactory(
    () => SplashBloc(
      tokenRepository: sl.get<TokenRepository>(),
    ),
  );
}