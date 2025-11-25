import 'package:medcon/app/profile/domain/models/user_profile_model.dart';

abstract class ProfileState {}

// initial state
class ProfileInitial extends ProfileState {}

// loaded state
class ProfileLoaded extends ProfileState {
  final UserProfileModel userProfileModel;
  ProfileLoaded({required this.userProfileModel});
}

// error state
class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}

// loading state  
class ProfileLoading extends ProfileState {}
