import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/util/mappable.dart';

class User implements Mappable {
  String email;

  final String bio;

  final String id;

  final String username;

  String password;

  final List<User> following;

  final String token;

  final int followerCount;

  Game currentGame;

  User({
    this.email,
    this.bio,
    this.id,
    this.username,
    this.following,
    this.token,
    this.followerCount,
    this.currentGame,
  });

  bool follows(User user) => following.contains(user);

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json['email'],
        bio: json['bio'],
        id: json['id'],
        username: json['username'],
        following: List.from(json['following'] ?? [])
            .map((e) => User.fromJson(e))
            .toList(),
        token: json['token'],
        followerCount: json['followerCount'],
        currentGame: json['currentGame'] == null
            ? null
            : Game.fromJson(json['currentGame']),
      );

  @override
  bool operator ==(Object object) =>
      object is User && object.username == username;

  @override
  int get hashCode => id.hashCode;

  @override
  Map<String, dynamic> toMap() => {
        'email': email,
        'bio': bio,
        'id': id,
        'username': username,
        'password': password,
        'token': token,
      };
}
