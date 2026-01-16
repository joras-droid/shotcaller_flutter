import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_client.dart';
import '../../core/cache/app_cache.dart';
import '../../core/cache/app_cache_impl.dart';
import '../../features/auth/auth_feature_di.dart';
import '../../features/user/user_feature_di.dart';

/// Global dependency injection container
final getIt = GetIt.instance;

/// Initialize all dependencies
/// Call this once at app startup
Future<void> initInjector() async {
  // Core dependencies
  await _registerCore();

  // Feature dependencies
  registerAuthFeature(getIt);
  registerUserFeature(getIt);
}

/// Register core dependencies (network, cache, etc.)
Future<void> _registerCore() async {
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // App Cache
  getIt.registerLazySingleton<AppCache>(
    () => AppCacheImpl(getIt<SharedPreferences>()),
  );

  // API Client
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(),
  );
}

