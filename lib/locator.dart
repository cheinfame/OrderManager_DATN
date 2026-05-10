import 'package:get_it/get_it.dart';
import 'package:packare_manage_web/data/repositories/staff_repository_impl.dart';
import 'package:packare_manage_web/data/services/staff_service.dart';
import '../data/repositories/order_repository_impl.dart';
import '../data/services/order_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/account_bloc/account_bloc.dart';
import 'blocs/map_bloc/map_bloc.dart';
import 'blocs/order_bloc/create_order_process_cubit.dart';
import 'blocs/order_bloc/order_bloc.dart';
import 'blocs/staff_bloc/staff_bloc.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/map_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/services/auth_service.dart';

import 'data/services/map_service.dart';
import 'data/services/shared_preferences_service.dart';
import 'data/services/user_service.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Register SharedPreferencesService with error handling
  try {
    final prefs = await SharedPreferences.getInstance();
    locator.registerLazySingleton<SharedPreferencesService>(
      () => SharedPreferencesService(prefs: prefs),
    );
  } catch (error) {
    // Handle error getting SharedPreferences (e.g., logging, displaying message)
    print('Error getting SharedPreferences: $error');
  }

  // Register Auth
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => AuthRepositoryImpl(
        authService: locator<AuthService>(),
        sharedPreferencesService: locator<SharedPreferencesService>(),
      ));

  // Register UserRepositoryImpl
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => UserRepositoryImpl(
        userApiService: locator<UserService>(),
        sharedPreferencesService: locator<SharedPreferencesService>(),
      ));

  // Register OrderRepoImpl
  locator.registerLazySingleton(() => OrderService());
  locator.registerLazySingleton(() => OrderRepositoryImpl(
        orderApiService: locator<OrderService>(),
        sharedPreferencesService: locator<SharedPreferencesService>(),
      ));

  // Register StaffRepositoryImpl
  locator.registerLazySingleton(() => StaffService());
  locator.registerLazySingleton(() => StaffRepositoryImpl(
        staffService: locator<StaffService>(),
        sharedPreferencesService: locator<SharedPreferencesService>(),
      ));

  // Register Staff Bloc
  locator.registerLazySingleton(() => StaffBloc(
    staffRepository: locator<StaffRepositoryImpl>(),
    userRepository: locator<UserRepositoryImpl>(),
  ));

  // Register Account Bloc
  locator.registerFactory(() => AccountBloc(
        authRepository: locator<AuthRepositoryImpl>(),
        userRepository: locator<UserRepositoryImpl>(),
      ));

  // Register Order Bloc
  locator.registerFactory(() => OrderBloc(
    userRepositoryImpl: locator<UserRepositoryImpl>(),
        staffRepositoryImpl: locator<StaffRepositoryImpl>(),
        orderRepository: locator<OrderRepositoryImpl>(),
      ));
}
