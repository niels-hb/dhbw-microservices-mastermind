import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

class DatabaseService extends ChangeNotifier with BlocState {
  Database _db;

  Database get db => _db;

  StoreRef<String, Map<String, dynamic>> gamesStore =
      stringMapStoreFactory.store('games');
  StoreRef<String, Map<String, dynamic>> settingsStore =
      stringMapStoreFactory.store('settings');
  StoreRef<String, Map<String, dynamic>> presetsStore =
      stringMapStoreFactory.store('presets');

  DatabaseService() {
    _initDatabase();
  }

  void _initDatabase() async {
    state = BlocStateSelector.waiting;

    DatabaseFactory databaseFactory = databaseFactoryWeb;

    _db = await databaseFactory.openDatabase(
      'dhbw_swe_mastermind_frontend.db',
    );

    state = BlocStateSelector.created;
  }

  @override
  void dispose() {
    _db.close();

    super.dispose();
  }
}
