import 'package:dhbw_swe_mastermind_frontend/pages/settings/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/settings/view.dart';
import 'package:provider/provider.dart';

class SettingsModel {
  static final String route = 'settings';
  static final ChangeNotifierProvider<SettingsBloc> view =
      ChangeNotifierProvider<SettingsBloc>(
    create: (context) => SettingsBloc(context),
    child: SettingsView(),
  );
}
