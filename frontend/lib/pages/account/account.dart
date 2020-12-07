import 'package:dhbw_swe_mastermind_frontend/pages/account/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/account/view.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:provider/provider.dart';

class AccountModel {
  static final String route = 'account';
  static final ChangeNotifierProxyProvider<ApiService, AccountBloc> view =
      ChangeNotifierProxyProvider<ApiService, AccountBloc>(
    create: (context) => AccountBloc(context),
    update: (context, apiService, previous) => previous
      ..apiService = apiService
      ..loadData(),
    child: AccountView(),
  );
}
