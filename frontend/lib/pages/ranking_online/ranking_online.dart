import 'package:dhbw_swe_mastermind_frontend/pages/ranking_online/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/ranking_online/view.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:provider/provider.dart';

class RankingOnlineModel {
  static final String route = 'ranking_online';
  static final ChangeNotifierProxyProvider2<ApiService, PresetsService,
          RankingOnlineBloc> view =
      ChangeNotifierProxyProvider2<ApiService, PresetsService,
          RankingOnlineBloc>(
    create: (context) => RankingOnlineBloc(context),
    update: (context, apiService, presetsService, previous) => previous
      ..apiService = apiService
      ..presetsService = presetsService
      ..loadInitialFilter()
      ..loadData(),
    child: RankingOnlineView(),
  );
}
