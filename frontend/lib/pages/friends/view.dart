import 'package:dhbw_swe_mastermind_frontend/pages/friends/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/connection_status.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Freunde'),
        ),
        floatingActionButton: _buildFAB(context),
        body: ConnectionStatus(
          child: Consumer<ApiService>(
            builder: (context, bloc, child) {
              if (bloc.state == BlocStateSelector.waiting &&
                  bloc.user == null) {
                return child;
              }

              if (bloc.user?.following?.isEmpty ?? true) {
                return Center(
                  child: Text('Keine Freunde!'),
                );
              }

              return Column(
                children: <Widget>[
                  _buildHeader(context),
                  _buildList(bloc),
                ],
              );
            },
            child: UIHelper.centeredProgressIndicator,
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) => FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Provider.of<FriendsBloc>(context).showUsersDialog(context),
      );

  Widget _buildHeader(BuildContext context) {
    ApiService bloc = Provider.of<ApiService>(context);

    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildCount(
              context: context,
              title: 'DU FOLGST',
              count: bloc.user.following.length,
            ),
            _buildCount(
              context: context,
              title: 'DIR FOLGEN',
              count: bloc.user.followerCount,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCount({
    BuildContext context,
    String title,
    int count,
  }) =>
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.caption,
            ),
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      );

  Expanded _buildList(ApiService bloc) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(32.0),
        itemCount: bloc.user.following.length,
        itemBuilder: (context, index) => UserCard.view(
          bloc.user.following[index],
        ),
      ),
    );
  }
}
