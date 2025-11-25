import 'package:medcon/app/authentication/domain/model/user_model.dart';

// Authentication repo will have outline methods of authentication.
abstract class AuthRepo {
  Future<AppUserModel?> register({
    required String name,
    required String email,
    required String password,
    required String accountType,
  });
  Future<AppUserModel?> login({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<AppUserModel?> getCurrentUser();
}
