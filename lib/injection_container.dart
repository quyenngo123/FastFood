import 'package:get_it/get_it.dart';
import 'package:fash_food/features/auth/domain/entities/user_entity.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fash_food/features/auth/domain/repositories/auth_repositories.dart';
import 'package:fash_food/features/auth/domain/usecases/login_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/register_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 1. Repository: Đăng ký kiểu AuthRepository (từ file auth_repositories.dart)
  sl.registerLazySingleton<AuthRepository>(() => MockAuthRepository());

  // 2. Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // 3. Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<UserEntity> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserEntity(uid: '123', email: email, fullName: 'User Test');
  }

  @override
  Future<UserEntity> register({required String fullName, required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserEntity(uid: '124', email: email, fullName: fullName);
  }

  @override
  Future<void> logout() async {}

  @override
  Future<UserEntity?> getCurrentUser() async => null;

  @override
  Future<UserEntity> loginWithFacebook() async => throw UnimplementedError();

  @override
  Future<UserEntity> loginWithGoogle() async => throw UnimplementedError();
}
