import 'package:dhbw_swe_mastermind_frontend/util/mappable.dart';
import 'package:flutter/material.dart';

class GameColor with Mappable {
  static final unselected = GameColor._(
    id: -1,
    name: 'transparent',
    color: Colors.transparent,
  );

  static const availableColors = [
    GameColor._(id: 1, name: 'green', color: Colors.green),
    GameColor._(id: 2, name: 'grey', color: Colors.grey),
    GameColor._(id: 3, name: 'red', color: Colors.red),
    GameColor._(id: 4, name: 'yellow', color: Colors.yellow),
    GameColor._(id: 5, name: 'brown', color: Colors.brown),
    GameColor._(id: 6, name: 'cyan', color: Colors.cyan),
    GameColor._(id: 7, name: 'teal', color: Colors.teal),
    GameColor._(id: 8, name: 'pink', color: Colors.pink),
  ];

  final int id;

  final String name;

  final Color color;

  const GameColor._({
    @required this.id,
    @required this.name,
    @required this.color,
  });

  factory GameColor.fromJson(Map<String, dynamic> json) =>
      availableColors.firstWhere(
        (gameColor) => gameColor.id == json['id'],
        orElse: () => unselected,
      );

  @override
  bool operator ==(Object object) => object is GameColor && object.id == id;

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
      };
}
