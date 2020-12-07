import 'package:dhbw_swe_mastermind_frontend/interfaces/game_color.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/rating.dart';
import 'package:dhbw_swe_mastermind_frontend/util/extensions.dart';
import 'package:dhbw_swe_mastermind_frontend/util/mappable.dart';
import 'package:flutter/material.dart';

class Round with Mappable {
  final int id;

  final List<GameColor> guess;

  final Rating rating;

  Round({
    this.id,
    @required this.guess,
    @required this.rating,
  });

  factory Round.fromJson(Map<String, dynamic> json) => Round(
        id: json['id'],
        guess: List.from(json['guess'])
            .map((gameColor) => GameColor.fromJson(gameColor))
            .toList(),
        rating: Rating.fromJson(json['rating']),
      );

  @override
  Map<String, dynamic> toMap() => {
        'guess': guess.toMappedList(),
        'rating': rating.toMap(),
      };
}
