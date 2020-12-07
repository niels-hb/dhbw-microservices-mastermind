import 'package:dhbw_swe_mastermind_frontend/services/database.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:dhbw_swe_mastermind_frontend/util/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

class SettingsService extends ChangeNotifier with BlocState, DatabaseHelper {
  static const String _PRI_COL = 'PRIMARY_COLOR';
  static const String _SEC_COL = 'SECONDARY_COLOR';

  static const String _COL_IND_SHP = 'COLOR_INDICATOR_SHAPE';

  static const String _PIN_SHP = 'PIN_SHAPE';
  static const String _EXA_PIN_COL = 'EXACT_PIN_COLOR';
  static const String _PAR_PIN_COL = 'PART_PIN_COLOR';

  static const _DEFAULT_SETTINGS = {
    _PRI_COL: Color(0xFF4B3B69),
    _SEC_COL: Color(0xFFA54E74),
    _COL_IND_SHP: BoxShape.circle,
    _PIN_SHP: BoxShape.circle,
    _EXA_PIN_COL: Colors.white,
    _PAR_PIN_COL: Colors.black,
  };

  DatabaseService databaseService;

  StoreRef<String, Map<String, dynamic>> get store =>
      databaseService.settingsStore;

  Map<String, dynamic> values = Map.from(_DEFAULT_SETTINGS);

  Color get primaryColor => values[_PRI_COL];
  set primaryColor(Color color) => putRecord(
        _PRI_COL,
        color,
      );

  Color get secondaryColor => values[_SEC_COL];
  set secondaryColor(Color color) => putRecord(
        _SEC_COL,
        color,
      );

  BoxShape get colorIndicatorShape => values[_COL_IND_SHP];
  set colorIndicatorShape(BoxShape boxShape) => putRecord(
        _COL_IND_SHP,
        boxShape,
      );

  BoxShape get pinShape => values[_PIN_SHP];
  set pinShape(BoxShape boxShape) => putRecord(
        _PIN_SHP,
        boxShape,
      );

  Color get exactMatchPinColor => values[_EXA_PIN_COL];
  set exactMatchPinColor(Color color) => putRecord(
        _EXA_PIN_COL,
        color,
      );

  Color get partMatchPinColor => values[_PAR_PIN_COL];
  set partMatchPinColor(Color color) => putRecord(
        _PAR_PIN_COL,
        color,
      );

  Future<void> loadSettings() async {
    if (databaseService.state == BlocStateSelector.created) {
      state = BlocStateSelector.waiting;

      await getAndAssignColor(_PRI_COL);
      await getAndAssignColor(_SEC_COL);

      await getAndAssignBoxShape(_COL_IND_SHP);

      await getAndAssignBoxShape(_PIN_SHP);
      await getAndAssignColor(_EXA_PIN_COL);
      await getAndAssignColor(_PAR_PIN_COL);

      state = BlocStateSelector.created;
    }
  }

  Future<void> reset() async {
    await store.drop(databaseService.db);

    values = Map.from(_DEFAULT_SETTINGS);
    notifyListeners();
  }
}
