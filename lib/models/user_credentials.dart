import 'dart:convert';

class UserCredentials {
  String? username;
  String? email;
  String? uid;

  UserCredentials({
    required this.username,
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'uid': uid,
    };
  }

  factory UserCredentials.fromMap(Map<String, dynamic> map) {
    return UserCredentials(
      username: map['username'] as String,
      email: map['email'] as String,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserCredentials.fromJson(String source) =>
      UserCredentials.fromMap(json.decode(source) as Map<String, dynamic>);
}
