import 'package:dhbw_swe_mastermind_frontend/pages/home/home.dart';
import 'package:dhbw_swe_mastermind_frontend/services/settings.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:flutter/material.dart';

class SplashBloc extends ChangeNotifier {
  final BuildContext context;

  SplashBloc(this.context);

  void showHomeIfReady(SettingsService settingsService) async {
    if (settingsService.state == BlocStateSelector.created) {
      Future.microtask(
        () => Navigator.of(context).pushReplacementNamed(HomeModel.route),
      );
    }
  }
}
