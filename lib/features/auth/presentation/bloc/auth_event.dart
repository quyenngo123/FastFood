import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Thêm event này
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

class GoogleLoginRequested extends AuthEvent {
  const GoogleLoginRequested();
}

class FacebookLoginRequested extends AuthEvent {
  const FacebookLoginRequested();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
