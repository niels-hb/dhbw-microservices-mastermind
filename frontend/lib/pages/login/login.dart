import 'package:dhbw_swe_mastermind_frontend/pages/login/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/pages/login/view.dart';
import 'package:provider/provider.dart';

class LoginModel {
  static final route = 'login';
  static final ChangeNotifierProvider<LoginBloc> view = ChangeNotifierProvider(
    create: (context) => LoginBloc(context),
    child: LoginView(),
  );
}
