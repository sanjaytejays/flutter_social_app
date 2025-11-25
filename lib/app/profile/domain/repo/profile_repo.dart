import 'package:medcon/app/profile/domain/models/user_profile_model.dart';

abstract class ProfileRepo {

  // update profile
  Future<void> updateProfile({required UserProfileModel userProfileModel});

  // get profile
  Future<UserProfileModel?> getProfile({required String uid});
}