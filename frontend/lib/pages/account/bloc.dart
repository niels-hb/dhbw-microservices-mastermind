import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountBloc extends ChangeNotifier with BlocState {
  final BuildContext context;

  ApiService apiService;

  String email;

  String password;

  AccountBloc(this.context);

  void loadData() async {
    try {
      state = BlocStateSelector.waiting;

      email = apiService.user.email;

      state = BlocStateSelector.created;
    } catch (e) {
      print(e);
      state = BlocStateSelector.error;
    }
  }

  void updateData(BuildContext context) async {
    try {
      await apiService.usersPutMe(email: email, password: password);
      await apiService.loadUser();

      _showConfirmationDialog(context);
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    loadData();
  }

  void deleteData() async {
    try {
      state = BlocStateSelector.waiting;

      await apiService.usersDeleteMe();
      Provider.of<PresetsService>(context).oauthAccessToken = null;
      Navigator.of(context).popUntil((route) => route.isFirst);

      state = BlocStateSelector.created;
    } catch (e) {
      print(e);
      state = BlocStateSelector.error;
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Daten geändert!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Neue E-Mail: $email'),
            if (password != null) ...[
              UIHelper.verticalSpaceDefault,
              Text('Neues Passwort: $password'),
            ],
          ],
        ),
      ),
    );
  }
}
