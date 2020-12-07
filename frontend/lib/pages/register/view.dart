import 'package:dhbw_swe_mastermind_frontend/pages/register/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/util/validators.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/button.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/connection_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registrieren'),
        ),
        body: ConnectionStatus(
          child: Form(
            key: Provider.of<RegisterBloc>(context).formStateKey,
            child: ListView(
              padding: EdgeInsets.all(32.0),
              children: <Widget>[
                UIHelper.buildTextField(
                  label: 'E-Mail',
                  onChanged: (email) =>
                      Provider.of<RegisterBloc>(context).email = email,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                UIHelper.verticalSpaceDefault,
                UIHelper.buildTextField(
                  label: 'Username',
                  onChanged: (username) =>
                      Provider.of<RegisterBloc>(context).username = username,
                  validator: Validators.username,
                ),
                UIHelper.verticalSpaceDefault,
                UIHelper.buildTextField(
                  label: 'Passwort',
                  onChanged: (password) =>
                      Provider.of<RegisterBloc>(context).password = password,
                  validator: Validators.password,
                  keyboardType: TextInputType.visiblePassword,
                ),
                UIHelper.verticalSpaceDefault,
                Builder(
                  builder: (context) => AppButton(
                    icon: Icon(Icons.send),
                    color: Colors.pink,
                    borderColor: Colors.pinkAccent,
                    title: 'REGISTRIEREN',
                    onPressed: () =>
                        Provider.of<RegisterBloc>(context).register(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
