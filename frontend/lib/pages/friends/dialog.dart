import 'package:dhbw_swe_mastermind_frontend/interfaces/user.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/util/validators.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/scrollable_alert_dialog.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersDialog {
  static final ChangeNotifierProxyProvider<ApiService, _UsersDialogBloc> view =
      ChangeNotifierProxyProvider(
    create: (context) => _UsersDialogBloc(context),
    update: (context, apiService, previous) =>
        previous..apiService = apiService,
    child: _UsersDialogView(),
  );
}

class _UsersDialogView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableAlertDialog(
      title: Text('Freunde finden'),
      content: Column(
        children: <Widget>[
          _buildSearchField(context),
          UIHelper.verticalSpaceDefault,
          _buildList(),
        ],
      ),
      actions: _buildActions(context),
    );
  }

  TextFormField _buildSearchField(BuildContext context) {
    return UIHelper.buildTextField(
      label: 'Benutzername',
      onChanged: (username) =>
          Provider.of<_UsersDialogBloc>(context).username = username,
      validator: Validators.username,
    );
  }

  Consumer<_UsersDialogBloc> _buildList() {
    return Consumer<_UsersDialogBloc>(
      builder: (context, bloc, child) {
        if (bloc.state == BlocStateSelector.waiting) {
          return child;
        }

        if (bloc.users == null) {
          return Text('Zum Suchen Benutzernamen eingeben.');
        }

        if (bloc.users.isEmpty ?? true) {
          return Text('Keine Benutzer gefunden!');
        }

        return Flexible(
          child: ListView.builder(
            itemCount: bloc.users.length,
            itemBuilder: (context, index) => UserCard.view(bloc.users[index]),
          ),
        );
      },
      child: UIHelper.centeredProgressIndicator,
    );
  }

  List<Widget> _buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: Provider.of<_UsersDialogBloc>(context).getUsers,
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: Navigator.of(context).pop,
        ),
      ];
}

class _UsersDialogBloc extends ChangeNotifier with BlocState {
  final BuildContext context;

  ApiService apiService;

  String username;

  List<User> users;

  _UsersDialogBloc(this.context);

  Future<void> getUsers() async {
    try {
      state = BlocStateSelector.waiting;

      users = await apiService.usersGetAll(username);
      users.remove(apiService.user);

      state = BlocStateSelector.created;
    } catch (e) {
      print(e);
      state = BlocStateSelector.error;
    }
  }
}
