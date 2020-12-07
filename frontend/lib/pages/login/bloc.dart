import 'package:dhbw_swe_mastermind_frontend/pages/home_online/home_online.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/register/register.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginBloc extends ChangeNotifier {
  final GlobalKey<FormState> formStateKey = GlobalKey();

  final BuildContext context;

  String email;

  String password;

  LoginBloc(this.context);

  void login(BuildContext context) async {
    if (!formStateKey.currentState.validate()) {
      return;
    }

    try {
      Provider.of<PresetsService>(context).oauthAccessToken =
          await Provider.of<ApiService>(context).usersLogin(
        email: email,
        password: password,
      );

      Navigator.of(context).pushReplacementNamed(HomeOnlineModel.route);
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void register() {
    Navigator.of(context).pushReplacementNamed(RegisterModel.route);
  }
}
