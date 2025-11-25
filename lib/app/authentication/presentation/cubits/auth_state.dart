import 'package:medcon/app/authentication/domain/model/user_model.dart';

// Auth States

abstract class AuthState {}

// initial state
class AuthInitial extends AuthState {}

// loading state
class AuthLoading extends AuthState {}

// authenticated state
class Authenticated extends AuthState {
  final AppUserModel? user;
  Authenticated({required this.user});
}

// unauthenticated state
class UnAuthenticated extends AuthState {}

// error state
class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}

// logout state
class AuthLogout extends AuthState {}

