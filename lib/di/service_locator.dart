import 'package:get_it/get_it.dart';
import 'package:gifts_manager/data/storage/shared_preference_data.dart';

import '../data/repository/refresh_token_provider.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  sl.registerLazySingleton(() => SharedPreferenceData());
  sl.registerLazySingleton<RefreshTokenProvider>(
    () => sl.get<SharedPreferenceData>(),
  );
}
