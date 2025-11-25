import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcon/app/profile/domain/models/user_profile_model.dart';
import 'package:medcon/app/profile/domain/repo/profile_repo.dart';
import 'package:medcon/app/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  // fetch user profile using repo
  Future<void> getProfileCubit({required String uid}) async {
    try {
      emit(ProfileLoading());
      final userProfileModel = await profileRepo.getProfile(uid: uid);
      if (userProfileModel != null) {
        emit(ProfileLoaded(userProfileModel: userProfileModel));
      } else {
        emit(ProfileError(message: "User profile not found.."));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  // update user profile using repo
  Future<void> updateProfileCubit({
    required String uid,
    String? name,
    String? profilePicUrl,
    String? aboutMe,
    String? accountType,
    String? headLine,
    String? dateOfBirth,
    String? location,
    List<String>? skills,
    int? yearsExperience,
    List<ExperienceEntry>? experience,
    List<EducationEntry>? education,
  }) async {
    emit(ProfileLoading());
    try {
      final currentUser = await profileRepo.getProfile(uid: uid);

      if (currentUser == null) {
        emit(
          ProfileError(
            message: "Failed to fetch user profile to update profile",
          ),
        );
        return;
      }

      final updatedProfile = currentUser.copyWith(
        name: name ?? currentUser.name,
        profilePicUrl: profilePicUrl ?? currentUser.profilePicUrl,
        aboutMe: aboutMe ?? currentUser.aboutMe,
        accountType: accountType ?? currentUser.accountType,
        headLine: headLine ?? currentUser.headLine,
        dateOfBirth: dateOfBirth ?? currentUser.dateOfBirth,
        location: location ?? currentUser.location,
        skills: skills ?? currentUser.skills,
        experience: experience ?? currentUser.experience,
        education: education ?? currentUser.education,
      );

      await profileRepo.updateProfile(userProfileModel: updatedProfile);

      await getProfileCubit(uid: uid);
    } catch (e) {
      emit(ProfileError(message: e.toString() + "Failed to update profile"));
    }
  }
}
