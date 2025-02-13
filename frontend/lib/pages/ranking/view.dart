import 'package:dhbw_swe_mastermind_frontend/pages/ranking/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/confirmation_dialog.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/game_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ranking'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => ConfirmationDialog.show(
                context: context,
                title: 'Spiele löschen?',
                onAccept: () => Provider.of<RankingBloc>(context).reset(),
              ),
            ),
          ],
        ),
        floatingActionButton: _buildFilterFAB(context),
        body: _buildHistory(context),
      ),
    );
  }

  FloatingActionButton _buildFilterFAB(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.filter_list),
      onPressed: () => Provider.of<RankingBloc>(context).editFilter(),
    );
  }

  Consumer _buildHistory(BuildContext context) {
    return Consumer<RankingBloc>(
      builder: (context, bloc, child) {
        if (bloc.state == BlocStateSelector.waiting) {
          return child;
        } else if (bloc.state == BlocStateSelector.created) {
          if (bloc.games?.isEmpty ?? true) {
            return Center(
              child: Text('Keine Spiele gefunden.'),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(32.0),
            itemCount: bloc.games.length,
            itemBuilder: (BuildContext context, int index) => GameCard.view(
              bloc.games[index],
            ),
          );
        } else {
          return Center(
            child: Text('Inhalt konnte nicht geladen werden.'),
          );
        }
      },
      child: UIHelper.centeredProgressIndicator,
    );
  }
}
