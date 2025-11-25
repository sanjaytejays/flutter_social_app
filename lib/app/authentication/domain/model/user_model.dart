class AppUserModel {
  final String uid;
  final String email;
  final String name;
  final String accountType;

  AppUserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.accountType,
  });

  // Convert a User into a Map(json).
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'accountType': accountType,
    };
  }

  // Extract a User from a Map(json).
  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      accountType: map['accountType'],
    );
  }
}
