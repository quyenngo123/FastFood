import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Auth
import 'package:fash_food/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fash_food/features/auth/presentation/bloc/address_bloc.dart';
import 'package:fash_food/features/auth/domain/repositories/auth_repositories.dart';
import 'package:fash_food/features/auth/domain/usecases/login_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/register_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/update_user_profile_usecase.dart';
import 'package:fash_food/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:fash_food/features/auth/data/datasources/address_remote_data_source.dart';

// Food & Cart & Voucher & Favorite
import 'package:fash_food/features/food/data/datasources/cart_remote_data_source.dart';
import 'package:fash_food/features/food/data/datasources/food_remote_data_source.dart';
import 'package:fash_food/features/food/data/datasources/voucher_remote_data_source.dart';
import 'package:fash_food/features/food/data/datasources/favorite_remote_data_source.dart';
import 'package:fash_food/features/food/presentation/bloc/cart_bloc.dart';
import 'package:fash_food/features/food/presentation/bloc/food_bloc.dart';
import 'package:fash_food/features/food/presentation/bloc/voucher_bloc.dart';
import 'package:fash_food/features/food/presentation/bloc/favorite_bloc.dart';

// Orders
import 'package:fash_food/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:fash_food/features/orders/presentation/bloc/order_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton(() => FirebaseFirestore.instance);
  }
  if (!sl.isRegistered<FirebaseAuth>()) {
    sl.registerLazySingleton(() => FirebaseAuth.instance);
  }

  // 1. Data Sources
  sl.registerLazySingleton(() => UserRemoteDataSource(firestore: sl()));
  sl.registerLazySingleton(() => AddressRemoteDataSource(firestore: sl()));
  sl.registerLazySingleton(() => CartRemoteDataSource(firestore: sl()));
  sl.registerLazySingleton(() => FoodRemoteDataSource(firestore: sl()));
  sl.registerLazySingleton(() => OrderRemoteDataSource(firestore: sl()));
  sl.registerLazySingleton(() => VoucherRemoteDataSource(firestore: sl()));
  sl.registerLazySingleton(() => FavoriteRemoteDataSource(firestore: sl()));

  // 2. Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));

  // 3. Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(sl()));

  // 4. Bloc
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    registerUseCase: sl(),
    logoutUseCase: sl(),
    getCurrentUserUseCase: sl(),
  ));

  sl.registerFactory(() => AddressBloc(remoteDataSource: sl()));
  sl.registerFactory(() => CartBloc(remoteDataSource: sl()));
  sl.registerFactory(() => FoodBloc(remoteDataSource: sl()));
  sl.registerFactory(() => OrderBloc(orderRemoteDataSource: sl()));
  sl.registerFactory(() => VoucherBloc(remoteDataSource: sl()));
  sl.registerFactory(() => FavoriteBloc(remoteDataSource: sl()));
}
