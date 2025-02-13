import 'package:dhbw_swe_mastermind_frontend/pages/history/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/connection_status.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/game_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Historie'),
        ),
        body: ConnectionStatus(
          child: _buildList(),
        ),
      ),
    );
  }

  Consumer<HistoryBloc> _buildList() {
    return Consumer<HistoryBloc>(
      builder: (context, bloc, child) {
        if (bloc.state == BlocStateSelector.waiting) {
          return child;
        }

        if (bloc.history?.isEmpty ?? true) {
          return Center(
            child: Text('Keine Spiele!'),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(32.0),
          itemCount: bloc.history.length,
          itemBuilder: (context, index) => GameCard.view(
            bloc.history[index],
          ),
        );
      },
      child: UIHelper.centeredProgressIndicator,
    );
  }
}
