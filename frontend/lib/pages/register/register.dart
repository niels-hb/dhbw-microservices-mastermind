import 'package:dhbw_swe_mastermind_frontend/pages/register/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/register/view.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:provider/provider.dart';

class RegisterModel {
  static final route = 'register';
  static final view = ChangeNotifierProxyProvider<ApiService, RegisterBloc>(
    create: (context) => RegisterBloc(context),
    update: (context, apiService, previous) =>
        previous..apiService = apiService,
    child: RegisterView(),
  );
}
