class AuthUser {
  const AuthUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.preferredLanguage,
    required this.isActive,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'] as String,
    fullName: json['full_name'] as String,
    email: json['email'] as String,
    preferredLanguage: json['preferred_language'] as String,
    isActive: json['is_active'] as bool,
  );

  final String id;
  final String fullName;
  final String email;
  final String preferredLanguage;
  final bool isActive;
}
