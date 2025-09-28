class User {
  final int id;
  final String fullName;
  final String userName;
  final String phoneNumber;
  final String email;
  final String? emailVerifiedAt;
  final String? referralCode;
  final String? heardAboutUs;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.phoneNumber,
    required this.email,
    this.emailVerifiedAt,
    this.referralCode,
    this.heardAboutUs,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      userName: json['user_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      referralCode: json['referral_code'],
      heardAboutUs: json['heard_about_us'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'user_name': userName,
      'phone_number': phoneNumber,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'referral_code': referralCode,
      'heard_about_us': heardAboutUs,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
