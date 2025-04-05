import 'package:equatable/equatable.dart';

//Equatable klasa dziedziczna potrzebna do
//porównywania obiektów typu User przy uwierzytelnianiu
class UserModel extends Equatable {
  final int? id;
  String username;
  final String email;
  final String passwordHash;

    UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
});

  Map<String, dynamic> toMap() => {
    'id': id,
    'username': username,
    'email': email,
    'password': passwordHash,
  };

  factory UserModel.fromMap(Map<String,dynamic> map) => UserModel
    (
    id: map['id'],
    username: map['username'],
    email: map['email'],
    passwordHash: map['password']
  );

  @override
  List<Object?> get props => [id, username, email, passwordHash];
}
