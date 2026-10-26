class User {
  final String username;
  final String password;

  const User({required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return {'username': this.username, 'password': this.password};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }
}

class UserPublic {
  final int id;
  final String username;

  const UserPublic({required this.id, required this.username});

  Map<String, dynamic> toMap() {
    return {'id': this.id, 'username': this.username};
  }

  factory UserPublic.fromMap(Map<String, dynamic> map) {
    return UserPublic(
      id: map['id'] as int,
      username: map['username'] as String,
    );
  }

  @override
  String toString() {
    return 'UserPublic{id: $id, username: $username}';
  }
}
