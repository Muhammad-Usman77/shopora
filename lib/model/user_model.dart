class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? map['_id'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      role: map['role'] ?? "user",
    );
  }

  bool get isAdmin => role == "admin";
  bool get isUser => role == "user";
}