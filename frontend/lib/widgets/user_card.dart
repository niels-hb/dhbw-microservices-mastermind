import 'package:dhbw_swe_mastermind_frontend/interfaces/user.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCard {
  static ChangeNotifierProvider<_UserCardBloc> view(User user) =>
      ChangeNotifierProvider<_UserCardBloc>(
        create: (context) => _UserCardBloc(context),
        child: _UserCardView(user),
      );
}

class _UserCardView extends StatelessWidget {
  final User user;

  _UserCardView(this.user);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: _buildContent(context),
      ),
    );
  }

  Row _buildContent(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: _buildTitle(context),
          ),
          _buildAction(context),
        ],
      );

  Text _buildTitle(BuildContext context) => Text(
        (user.username ?? 'Anonym').toUpperCase(),
        style: Theme.of(context).textTheme.subtitle1,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  IconButton _buildAction(BuildContext context) {
    Icon icon;
    Function onPressed;

    if (Provider.of<ApiService>(context).user.follows(user)) {
      icon = Icon(Icons.close);
      onPressed = () => Provider.of<_UserCardBloc>(context).unfollow(user);
    } else {
      icon = Icon(Icons.add);
      onPressed = () => Provider.of<_UserCardBloc>(context).follow(user);
    }

    return IconButton(
      icon: icon,
      visualDensity: VisualDensity.compact,
      onPressed: onPressed,
    );
  }
}

class _UserCardBloc extends ChangeNotifier with BlocState {
  final BuildContext context;

  _UserCardBloc(this.context);

  void follow(User user) async {
    await Provider.of<ApiService>(context).usersFollow(user.username);
    await Provider.of<ApiService>(context).loadUser();
    notifyListeners();
  }

  void unfollow(User user) async {
    await Provider.of<ApiService>(context).usersUnfollow(user.username);
    await Provider.of<ApiService>(context).loadUser();
    notifyListeners();
  }
}
