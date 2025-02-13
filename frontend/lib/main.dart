import 'package:dhbw_swe_mastermind_frontend/pages/about/about.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/account/account.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/friends/friends.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/help/help.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/history/history.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/home/home.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/home_online/home_online.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/login/login.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/new_game/new_game.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/ranking/ranking.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/ranking_online/ranking_online.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/register/register.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/settings/settings.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/splash/splash.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/services/database.dart';
import 'package:dhbw_swe_mastermind_frontend/services/game.dart';
import 'package:dhbw_swe_mastermind_frontend/services/presets.dart';
import 'package:dhbw_swe_mastermind_frontend/services/settings.dart';
import 'package:dhbw_swe_mastermind_frontend/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        ChangeNotifierProxyProvider<DatabaseService, SettingsService>(
          create: (_) => SettingsService(),
          update: (_, databaseService, previous) => previous
            ..databaseService = databaseService
            ..loadSettings(),
        ),
        ChangeNotifierProxyProvider<DatabaseService, PresetsService>(
          create: (_) => PresetsService(),
          update: (_, databaseService, previous) => previous
            ..databaseService = databaseService
            ..loadPresets(),
        ),
        ChangeNotifierProxyProvider<PresetsService, ApiService>(
          create: (_) => ApiService(),
          update: (_, presetsService, previous) => previous
            ..presetsService = presetsService
            ..loadUser(),
        ),
        ProxyProvider2<DatabaseService, ApiService, GameService>(
          update: (_, databaseService, apiService, previous) =>
              (previous ?? GameService())
                ..databaseService = databaseService
                ..apiService = apiService,
        ),
      ],
      child: Consumer<SettingsService>(
        builder: (BuildContext context, SettingsService bloc, Widget child) {
          return MaterialApp(
            title: 'Mastermind',
            theme: ThemeData(
              primaryColor: bloc.primaryColor,
              accentColor: bloc.secondaryColor,
              brightness: bloc.primaryColor.brightness(),
              primaryColorBrightness: bloc.primaryColor.brightness(),
              accentColorBrightness: bloc.secondaryColor.brightness(),
              scaffoldBackgroundColor: Colors.transparent,
            ),
            initialRoute: SplashModel.route,
            onUnknownRoute: (_) => MaterialPageRoute(
              builder: (_) => HomeModel.view,
            ),
            routes: {
              SplashModel.route: (context) => SplashModel.view,
              HomeModel.route: (context) => HomeModel.view,
              AboutModel.route: (context) => AboutModel.view,
              HelpModel.route: (context) => HelpModel.view,
              SettingsModel.route: (context) => SettingsModel.view,
              RankingModel.route: (context) => RankingModel.view,
              NewGameModel.routeForOfflineComputer: (context) =>
                  NewGameModel.viewForOfflineComputer,
              NewGameModel.routeForOfflinePlayer: (context) =>
                  NewGameModel.viewForOfflinePlayer,
              NewGameModel.routeForOnlineComputer: (context) =>
                  NewGameModel.viewForOnlineComputer,
              LoginModel.route: (context) => LoginModel.view,
              RegisterModel.route: (context) => RegisterModel.view,
              HomeOnlineModel.route: (context) => HomeOnlineModel.view,
              HistoryModel.route: (context) => HistoryModel.view,
              RankingOnlineModel.route: (context) => RankingOnlineModel.view,
              FriendsModel.route: (context) => FriendsModel.view,
              AccountModel.route: (context) => AccountModel.view,
            },
          );
        },
      ),
    );
  }
}
