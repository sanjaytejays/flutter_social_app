import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcon/app/authentication/domain/model/user_model.dart';
import 'package:medcon/app/authentication/domain/repo/auth_repo.dart';
import 'package:medcon/app/authentication/presentation/cubits/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUserModel? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  // check user is logged in or not
  void checkAuthCubit() async {
    final AppUserModel? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user: _currentUser));
    } else {
      emit(UnAuthenticated());
    }
  }

  // get current user
  AppUserModel? get currentUser => _currentUser;

  // register
  Future<void> registerCubit({
    required String name,
    required String email,
    required String password,
    required String accountType,
  }) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.register(
        name: name,
        email: email,
        password: password,
        accountType: accountType,
      );
      _currentUser = user;
      emit(Authenticated(user: _currentUser));
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(UnAuthenticated());
    }
  }

  // login
  Future<void> loginCubit({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.login(email: email, password: password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user: _currentUser));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(UnAuthenticated());
    }
  }

  // logout
  void logoutCubit() async {
    emit(AuthLoading());
    try {
      await authRepo.logout();
      emit(UnAuthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(UnAuthenticated());
    }
  }
}
