import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medcon/app/profile/domain/models/user_profile_model.dart';
import 'package:medcon/app/profile/domain/repo/profile_repo.dart';

class ImplProfileRepo implements ProfileRepo {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<UserProfileModel?> getProfile({required String uid}) async {
    try {
      // get user profile document
      final userDoc = await _firebaseFirestore
          .collection("users")
          .doc(uid)
          .get();

      // if user profile document exists
      if (userDoc.exists) {
        final userDate = userDoc.data();

        if (userDate != null) {
          return UserProfileModel.fromMap(userDate);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile({
    required UserProfileModel userProfileModel,
  }) async {
    try {
      // covert update profile model to map and update in firestore
      await _firebaseFirestore
          .collection("users")
          .doc(userProfileModel.uid)
          .update({
            "email": userProfileModel.email,
            "name": userProfileModel.name,
            "profilePicUrl": userProfileModel.profilePicUrl,
            "aboutMe": userProfileModel.aboutMe,
            "accountType": userProfileModel.accountType,
            "headLine": userProfileModel.headLine,
            "dateOfBirth": userProfileModel.dateOfBirth,
            "location": userProfileModel.location,
            "skills": userProfileModel.skills,
            "experience": userProfileModel.experience
                .map((e) => e.toMap())
                .toList(),
            "education": userProfileModel.education
                .map((e) => e.toMap())
                .toList(),
          });
    } catch (e) {
      throw Exception("UPDATE PROFILE ERROR......$e");
    }
  }
}
