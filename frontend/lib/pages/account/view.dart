import 'package:dhbw_swe_mastermind_frontend/pages/account/bloc.dart';
import 'package:dhbw_swe_mastermind_frontend/util/bloc_state.dart';
import 'package:dhbw_swe_mastermind_frontend/util/ui_helper.dart';
import 'package:dhbw_swe_mastermind_frontend/util/validators.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/button.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/confirmation_dialog.dart';
import 'package:dhbw_swe_mastermind_frontend/widgets/connection_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIHelper.scaffoldBackground(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Account'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => ConfirmationDialog.show(
                context: context,
                title: 'Account löschen?',
                description:
                    'Diese Aktion kann nicht rückgängig gemacht werden!',
                onAccept: Provider.of<AccountBloc>(context).deleteData,
              ),
            ),
          ],
        ),
        body: ConnectionStatus(
          child: Consumer<AccountBloc>(
            builder: (context, bloc, child) {
              if (bloc.state == BlocStateSelector.waiting) {
                return child;
              }

              return ListView(
                padding: EdgeInsets.all(32.0),
                children: <Widget>[
                  Text(
                    'Hier kannst du bei Bedarf deine E-Mail Adresse ändern.',
                  ),
                  UIHelper.verticalSpaceDefault,
                  UIHelper.buildTextField(
                    label: 'E-Mail',
                    onChanged: (email) => bloc.email = email,
                    validator: Validators.email,
                    keyboardType: TextInputType.emailAddress,
                    initialValue: bloc.email,
                  ),
                  UIHelper.verticalSpaceDefault,
                  Text(
                    'Hier kannst du bei Bedarf dein Passwort ändern. (Leer lassen entspricht nicht ändern.)',
                  ),
                  UIHelper.verticalSpaceDefault,
                  UIHelper.buildTextField(
                    label: 'Passwort',
                    onChanged: (password) => bloc.password = password,
                    validator: Validators.password,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  UIHelper.verticalSpaceDefault,
                  Builder(
                    builder: (context) => AppButton(
                      icon: Icon(Icons.save),
                      color: Colors.green,
                      borderColor: Colors.greenAccent,
                      title: 'SPEICHERN',
                      onPressed: () => bloc.updateData(context),
                    ),
                  ),
                ],
              );
            },
            child: UIHelper.centeredProgressIndicator,
          ),
        ),
      ),
    );
  }
}
