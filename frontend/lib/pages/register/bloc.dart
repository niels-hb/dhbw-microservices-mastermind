import 'package:dhbw_swe_mastermind_frontend/pages/home_online/home_online.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterBloc extends ChangeNotifier {
  final GlobalKey<FormState> formStateKey = GlobalKey();

  final BuildContext context;

  ApiService apiService;

  String email;

  String username;

  String password;

  RegisterBloc(this.context);

  void register(BuildContext context) async {
    if (!formStateKey.currentState.validate()) {
      return;
    }

    try {
      await apiService.usersPost(
        email: email,
        username: username,
        password: password,
      );

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
}
