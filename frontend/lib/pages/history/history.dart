import 'package:dhbw_swe_mastermind_frontend/pages/history/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/history/view.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:provider/provider.dart';

class HistoryModel {
  static final String route = 'history';
  static final ChangeNotifierProxyProvider<ApiService, HistoryBloc> view =
      ChangeNotifierProxyProvider<ApiService, HistoryBloc>(
    create: (context) => HistoryBloc(context),
    update: (context, apiService, previous) => previous
      ..apiService = apiService
      ..loadData(),
    child: HistoryView(),
  );
}
