import 'package:dhbw_swe_mastermind_frontend/pages/splash/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/splash/view.dart';
import 'package:dhbw_swe_mastermind_frontend/services/settings.dart';
import 'package:provider/provider.dart';

class SplashModel {
  static final String route = 'splash';
  static final ChangeNotifierProxyProvider<SettingsService, SplashBloc> view =
      ChangeNotifierProxyProvider<SettingsService, SplashBloc>(
    create: (context) => SplashBloc(context),
    update: (_, settingsService, previous) =>
        previous..showHomeIfReady(settingsService),
    child: SplashView(),
  );
}
