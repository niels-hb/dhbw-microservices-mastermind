import 'dart:convert';

import 'package:dhbw_swe_mastermind_frontend/util/mappable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

extension Serialization on List<Mappable> {
  List<Map<String, dynamic>> toMappedList() =>
      map((mappable) => mappable.toMap()).toList();
}

extension Duplicate on List {
  bool hasDuplicates() => toSet().toList().length != length;
}

extension ColorUtil on Color {
  Brightness brightness() =>
      computeLuminance() > 0.5 ? Brightness.light : Brightness.dark;
}

extension JSON on Response {
  asJSON() => json.decode(body);
}
