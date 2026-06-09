import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fash_food/features/auth/domain/usecases/login_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/register_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_event.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        super(const AuthInitial()) {
    
    // Đăng ký handler cho sự kiện kiểm tra trạng thái
    on<CheckAuthRequested>(_onCheckAuthRequested);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<FacebookLoginRequested>(_onFacebookLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthRequested(
    CheckAuthRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Đợi 2 giây để hiển thị Splash Screen
      await Future.delayed(const Duration(seconds: 2));
      // Mặc định là chưa đăng nhập
      emit(const AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _loginUseCase(email: event.email, password: event.password);
      emit(AuthSuccess(userId: user.uid, email: user.email));
    } catch (e) {
      emit(AuthFailure(message: _mapFailureToMessage(e)));
    }
  }

  Future<void> _onRegisterSubmitted(RegisterSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _registerUseCase(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );
      emit(AuthSuccess(userId: user.uid, email: user.email));
    } catch (e) {
      emit(AuthFailure(message: _mapFailureToMessage(e)));
    }
  }

  String _mapFailureToMessage(Object e) {
    return e.toString().replaceAll('Exception: ', '');
  }

  Future<void> _onGoogleLoginRequested(GoogleLoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      emit(const AuthSuccess(userId: 'google_user', email: 'user@gmail.com'));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onFacebookLoginRequested(FacebookLoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      emit(const AuthSuccess(userId: 'fb_user', email: 'user@facebook.com'));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _logoutUseCase();
      emit(const AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
