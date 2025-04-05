class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String role;
  final String? bio;
  final UserType type;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.role,
    this.bio,
    required this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      role: json['role'],
      bio: json['bio'],
      type: json['type'] == 'student' ? UserType.student : UserType.teacher,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'role': role,
      'bio': bio,
      'type': type == UserType.student ? 'student' : 'teacher',
    };
  }
}

enum UserType {
  student,
  teacher,
}
