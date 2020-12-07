import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UIHelper.centeredProgressIndicator,
    );
  }
}
