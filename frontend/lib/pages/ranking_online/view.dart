import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/ranking_online/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/connection_status.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/game_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingOnlineView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'ME'),
                Tab(text: 'FREUNDE'),
                Tab(text: 'GLOBAL'),
              ],
            ),
            title: Text('Ranking'),
          ),
          floatingActionButton: _buildFilterFAB(context),
          body: ConnectionStatus(
            child: TabBarView(
              children: [
                _buildList(listSelector: (bloc) => bloc.me),
                _buildList(listSelector: (bloc) => bloc.friends),
                _buildList(listSelector: (bloc) => bloc.global),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton _buildFilterFAB(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.filter_list),
      onPressed: () => Provider.of<RankingOnlineBloc>(context).editFilter(),
    );
  }

  Widget _buildList({
    List<Game> Function(RankingOnlineBloc) listSelector,
  }) =>
      Consumer<RankingOnlineBloc>(
        builder: (context, bloc, child) {
          if (bloc.state == BlocStateSelector.waiting) {
            return child;
          }

          List<Game> games = listSelector(bloc);

          if (games?.isEmpty ?? true) {
            return Center(
              child: Text('Keine Spiele!'),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(32.0),
            itemCount: games.length,
            itemBuilder: (context, index) => GameCard.view(
              games[index],
            ),
          );
        },
        child: UIHelper.centeredProgressIndicator,
      );
}
