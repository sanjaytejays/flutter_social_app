import 'package:medcon/app/authentication/domain/model/user_model.dart';

class UserProfileModel extends AppUserModel {
  final String profilePicUrl;
  final String aboutMe;
  final String headLine;
  final String dateOfBirth;
  final String location;
  final List<String> skills;
  final List<ExperienceEntry> experience;
  final List<EducationEntry> education;

  UserProfileModel({
    required super.uid,
    required super.email,
    required super.name,
    required this.profilePicUrl,
    required this.aboutMe,
    required super.accountType,
    required this.headLine,
    required this.dateOfBirth,
    required this.location,
    required this.experience,
    required this.skills,
    required this.education,
  });

  UserProfileModel copyWith({
    String? name,
    String? profilePicUrl,
    String? aboutMe,
    String? accountType,
    String? headLine,
    String? dateOfBirth,
    String? location,
    List<ExperienceEntry>? experience,
    List<String>? skills,
    List<EducationEntry>? education,
  }) {
    return UserProfileModel(
      uid: uid,
      email: email,
      name: name ?? this.name,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      aboutMe: aboutMe ?? this.aboutMe,
      headLine: headLine ?? this.headLine,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      accountType: accountType ?? this.accountType,
      location: location ?? this.location,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      education: education ?? this.education,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'name': name,
    'profilePicUrl': profilePicUrl,
    'aboutMe': aboutMe,
    'accountType': accountType,
    'headLine': headLine,
    'dateOfBirth': dateOfBirth,
    'location': location,
    'skills': skills,
    'education': education.map((e) => e.toMap()).toList(), // Serialize list
    'experience': experience.map((e) => e.toMap()).toList(),
  };

  factory UserProfileModel.fromMap(Map<String, dynamic> map) =>
      UserProfileModel(
        uid: map['uid'] ?? '',
        email: map['email'] ?? '',
        name: map['name'] ?? '',
        profilePicUrl: map['profilePicUrl'] ?? '',
        aboutMe: map['aboutMe'] ?? '',
        accountType: map['accountType'] ?? '',
        headLine: map['headLine'] ?? '',
        dateOfBirth: map['dateOfBirth'] ?? '',
        location: map['location'] ?? '',
        skills: List<String>.from(map['skills'] ?? []),
        experience:
            (map['experience'] as List<dynamic>?)
                ?.map((e) => ExperienceEntry.fromMap(e as Map<String, dynamic>))
                .toList() ??
            [],
        education:
            (map['education'] as List<dynamic>?)
                ?.map((e) => EducationEntry.fromMap(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

// Helper class for Experience entries
class ExperienceEntry {
  final String role;
  final String organizationName;
  final String startDate;
  final String endDate;

  const ExperienceEntry({
    required this.role,
    required this.organizationName,
    required this.startDate,
    required this.endDate,
  });

  factory ExperienceEntry.fromMap(Map<String, dynamic> map) {
    return ExperienceEntry(
      role: map['role'] ?? '',
      organizationName: map['organizationName'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'organizationName': organizationName,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

// Helper class for Education entries
class EducationEntry {
  final String degree;
  final String institutionName;
  final String yearStart;
  final String yearEnd;

  const EducationEntry({
    required this.degree,
    required this.institutionName,
    required this.yearStart,
    required this.yearEnd,
  });

  factory EducationEntry.fromMap(Map<String, dynamic> map) {
    return EducationEntry(
      degree: map['degree'] ?? '',
      institutionName: map['institutionName'] ?? '',
      yearStart: map['yearStart'] ?? '',
      yearEnd: map['yearEnd'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'degree': degree,
      'institutionName': institutionName,
      'yearStart': yearStart,
      'yearEnd': yearEnd,
    };
  }
}
