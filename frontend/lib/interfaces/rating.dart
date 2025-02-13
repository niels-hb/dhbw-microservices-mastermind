import 'package:flutter/material.dart';

class Rating {
  final int exactMatch;

  final int partMatch;

  final int noMatch;

  int get sum => exactMatch + partMatch + noMatch;

  Rating({
    @required this.exactMatch,
    @required this.partMatch,
    @required this.noMatch,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        exactMatch: json['exactMatch'],
        partMatch: json['partMatch'],
        noMatch: json['noMatch'],
      );

  Map<String, dynamic> toMap() => {
        'exactMatch': exactMatch,
        'partMatch': partMatch,
        'noMatch': noMatch,
      };
}
