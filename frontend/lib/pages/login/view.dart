import 'package:dhbw_swe_mastermind_frontend/pages/login/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/util/validators.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/button.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/connection_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: ConnectionStatus(
          child: Form(
            key: Provider.of<LoginBloc>(context).formStateKey,
            child: ListView(
              padding: EdgeInsets.all(32.0),
              children: <Widget>[
                UIHelper.buildTextField(
                  label: 'E-Mail',
                  onChanged: (email) =>
                      Provider.of<LoginBloc>(context).email = email,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                UIHelper.verticalSpaceDefault,
                UIHelper.buildTextField(
                  label: 'Passwort',
                  onChanged: (password) =>
                      Provider.of<LoginBloc>(context).password = password,
                  validator: Validators.password,
                  keyboardType: TextInputType.visiblePassword,
                ),
                UIHelper.verticalSpaceDefault,
                Builder(
                  builder: (context) => AppButton(
                    icon: Icon(Icons.send),
                    color: Colors.pink,
                    borderColor: Colors.pinkAccent,
                    title: 'EINLOGGEN',
                    onPressed: () =>
                        Provider.of<LoginBloc>(context).login(context),
                  ),
                ),
                UIHelper.verticalSpaceDefault,
                AppButton(
                  icon: Icon(Icons.person_add),
                  color: Colors.yellow,
                  borderColor: Colors.yellowAccent,
                  title: 'REGISTRIEREN',
                  onPressed: Provider.of<LoginBloc>(context).register,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
