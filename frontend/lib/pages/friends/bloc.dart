import 'package:dhbw_swe_mastermind_frontend/pages/friends/dialog.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:flutter/material.dart';

class FriendsBloc extends ChangeNotifier with BlocState {
  final BuildContext context;

  ApiService apiService;

  FriendsBloc(this.context);

  void showUsersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => UsersDialog.view,
    );
  }
}
