import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

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

    DatabaseFactory databaseFactory = databaseFactoryIo;
    String appDocPath = (await getApplicationDocumentsDirectory()).path;

    _db = await databaseFactory.openDatabase(
      '$appDocPath/dhbw_swe_mastermind_frontend.db',
    );

    state = BlocStateSelector.created;
  }

  @override
  void dispose() {
    _db.close();

    super.dispose();
  }
}
