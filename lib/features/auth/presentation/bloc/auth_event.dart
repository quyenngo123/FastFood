import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthRequested extends AuthEvent {
  const CheckAuthRequested();
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterSubmitted extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterSubmitted({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [fullName, email, password, confirmPassword];
}

class UpdateProfileRequested extends AuthEvent {
  final UserEntity user;
  const UpdateProfileRequested(this.user);

  @override
  List<Object?> get props => [user];
}

class GoogleLoginRequested extends AuthEvent {
  const GoogleLoginRequested();
}

class FacebookLoginRequested extends AuthEvent {
  const FacebookLoginRequested();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
