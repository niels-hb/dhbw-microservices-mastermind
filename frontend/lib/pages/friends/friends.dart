import 'package:dhbw_swe_mastermind_frontend/pages/friends/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/friends/view.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:provider/provider.dart';

class FriendsModel {
  static final String route = 'friends';

  static final ChangeNotifierProxyProvider<ApiService, FriendsBloc> view =
      ChangeNotifierProxyProvider<ApiService, FriendsBloc>(
    create: (context) => FriendsBloc(context),
    update: (context, apiService, previous) =>
        previous..apiService = apiService,
    child: FriendsView(),
  );
}
