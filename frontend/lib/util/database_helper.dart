import 'package:dhbw_swe_mastermind_frontend/services/database.dart';
import 'package:dhbw_swe_mastermind_frontend/util/mappable.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

typedef ValueTransformer<T> = T Function(dynamic);

mixin DatabaseHelper on ChangeNotifier {
  DatabaseService get databaseService;

  StoreRef get store;

  Map<String, dynamic> values;

  Future<void> getAndAssignColor(String key) => getAndAssign(
        key,
        (color) => Color(color),
      );

  Future<void> getAndAssignBoxShape(String key) => getAndAssign(
        key,
        (boxShape) => BoxShape.values[boxShape],
      );

  Future<void> getAndAssign<T>(
    String key,
    ValueTransformer valueTransformer,
  ) async {
    T value = await getRecord(key, valueTransformer);

    if (value != null) {
      values[key] = value;
    }
  }

  Future<T> getRecord<T>(
    String key,
    ValueTransformer<T> valueTransformer,
  ) async {
    Map<String, dynamic> valueMap =
        await store.record(key).get(databaseService.db);

    dynamic value = valueMap?.containsKey(key) ?? false ? valueMap[key] : null;

    print('$runtimeType: Retrieved value $key: $value');

    return value == null ? null : valueTransformer(value);
  }

  Future<void> putRecord(String key, dynamic value) {
    values[key] = value;
    notifyListeners();

    dynamic convertedValue;

    if (value is Color) {
      convertedValue = value.value;
    } else if (value is BoxShape) {
      convertedValue = value.index;
    } else if (value is Mappable) {
      convertedValue = value.toMap();
    } else {
      convertedValue = value;
    }

    print('$runtimeType: Persisted value $key: $convertedValue');

    return store.record(key).put(databaseService.db, {key: convertedValue});
  }
}
