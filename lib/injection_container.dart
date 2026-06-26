import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Auth & Address
import 'package:fash_food/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fash_food/features/auth/presentation/bloc/address_bloc.dart';
import 'package:fash_food/features/auth/domain/repositories/auth_repositories.dart';
import 'package:fash_food/features/auth/domain/repositories/address_repository.dart';
import 'package:fash_food/features/auth/data/repositories/address_repository_impl.dart';
import 'package:fash_food/features/auth/domain/usecases/login_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/register_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/update_user_profile_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/login_with_facebook_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/get_addresses_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/save_address_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/delete_address_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/set_default_address_usecase.dart';
import 'package:fash_food/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:fash_food/features/auth/data/datasources/address_remote_data_source.dart';

// Food & Cart & Voucher & Favorite
import 'package:fash_food/features/food/data/datasources/cart_remote_data_source.dart';
import 'package:fash_food/features/food/data/datasources/food_remote_data_source.dart';
import 'package:fash_food/features/food/data/datasources/voucher_remote_data_source.dart';
import 'package:fash_food/features/food/data/datasources/favorite_remote_data_source.dart';
import 'package:fash_food/features/food/domain/repositories/food_repository.dart';
import 'package:fash_food/features/food/data/repositories/food_repository_impl.dart';
import 'package:fash_food/features/food/domain/usecases/watch_foods_usecase.dart';
import 'package:fash_food/features/food/domain/usecases/get_foods_usecase.dart';
import 'package:fash_food/features/food/domain/usecases/get_categories_usecase.dart';

import 'package:fash_food/features/food/domain/repositories/cart_repository.dart';
import 'package:fash_food/features/food/data/repositories/cart_repository_impl.dart';
import 'package:fash_food/features/food/domain/usecases/watch_cart_usecase.dart';
import 'package:fash_food/features/food/domain/usecases/get_cart_usecase.dart';
import 'package:fash_food/features/food/domain/usecases/update_cart_usecase.dart';
import 'package:fash_food/features/food/domain/usecases/delete_cart_usecase.dart';

import 'package:fash_food/features/food/domain/repositories/voucher_repository.dart';
import 'package:fash_food/features/food/data/repositories/voucher_repository_impl.dart';
import 'package:fash_food/features/food/domain/usecases/get_vouchers_usecase.dart';
import 'package:fash_food/features/food/domain/usecases/get_voucher_by_code_usecase.dart';

import 'package:fash_food/features/food/domain/repositories/favorite_repository.dart';
import 'package:fash_food/features/food/data/repositories/favorite_repository_impl.dart';
import 'package:fash_food/features/food/domain/usecases/get_favorites_usecase.dart';
import 'package:fash_food/features/food/domain/usecases/toggle_favorite_usecase.dart';

import 'package:fash_food/features/food/presentation/bloc/cart_bloc.dart';
import 'package:fash_food/features/food/presentation/bloc/food_bloc.dart';
import 'package:fash_food/features/food/presentation/bloc/voucher_bloc.dart';
import 'package:fash_food/features/food/presentation/bloc/favorite_bloc.dart';

// Orders
import 'package:fash_food/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:fash_food/features/orders/domain/repositories/order_repository.dart';
import 'package:fash_food/features/orders/data/repositories/order_repository_impl.dart';
import 'package:fash_food/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:fash_food/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:fash_food/features/orders/presentation/bloc/order_bloc.dart';

// Home & Notification
import 'package:fash_food/features/home/data/datasources/notification_remote_data_source.dart';
import 'package:fash_food/features/home/domain/repositories/notification_repository.dart';
import 'package:fash_food/features/home/data/repositories/notification_repository_impl.dart';
import 'package:fash_food/features/home/domain/usecases/watch_notifications_usecase.dart';
import 'package:fash_food/features/home/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:fash_food/features/home/presentation/bloc/notification_bloc.dart';

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
  sl.registerLazySingleton(() => NotificationRemoteDataSource(firestore: sl()));

  // 2. Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<AddressRepository>(() => AddressRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<FoodRepository>(() => FoodRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<VoucherRepository>(() => VoucherRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<FavoriteRepository>(() => FavoriteRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(remoteDataSource: sl()));

  // 3. Use cases
  // Auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithFacebookUseCase(sl()));
  
  // Address
  sl.registerLazySingleton(() => GetAddressesUseCase(sl()));
  sl.registerLazySingleton(() => SaveAddressUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAddressUseCase(sl()));
  sl.registerLazySingleton(() => SetDefaultAddressUseCase(sl()));

  // Food
  sl.registerLazySingleton(() => WatchFoodsUseCase(sl()));
  sl.registerLazySingleton(() => GetFoodsUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  // Cart
  sl.registerLazySingleton(() => WatchCartUseCase(sl()));
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCartUseCase(sl()));

  // Voucher
  sl.registerLazySingleton(() => GetVouchersUseCase(sl()));
  sl.registerLazySingleton(() => GetVoucherByCodeUseCase(sl()));

  // Favorite
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));

  // Order
  sl.registerLazySingleton(() => CreateOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));

  // Notification
  sl.registerLazySingleton(() => WatchNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationAsReadUseCase(sl()));

  // 4. Bloc
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    registerUseCase: sl(),
    logoutUseCase: sl(),
    getCurrentUserUseCase: sl(),
    updateUserProfileUseCase: sl(),
    loginWithGoogleUseCase: sl(),
    loginWithFacebookUseCase: sl(),
  ));

  sl.registerFactory(() => AddressBloc(
    getAddressesUseCase: sl(),
    saveAddressUseCase: sl(),
    deleteAddressUseCase: sl(),
    setDefaultAddressUseCase: sl(),
  ));
  
  sl.registerFactory(() => FoodBloc(watchFoodsUseCase: sl()));
  
  sl.registerFactory(() => CartBloc(
    getCartUseCase: sl(),
    updateCartUseCase: sl(),
    deleteCartUseCase: sl(),
  ));
  
  sl.registerFactory(() => OrderBloc(
    createOrderUseCase: sl(),
    getOrdersUseCase: sl(),
  ));
  
  sl.registerFactory(() => VoucherBloc(
    getVouchersUseCase: sl(),
    getVoucherByCodeUseCase: sl(),
  ));
  
  sl.registerFactory(() => FavoriteBloc(
    getFavoritesUseCase: sl(),
    toggleFavoriteUseCase: sl(),
  ));
  
  sl.registerFactory(() => NotificationBloc(
    watchNotificationsUseCase: sl(),
    markNotificationAsReadUseCase: sl(),
  ));
}
