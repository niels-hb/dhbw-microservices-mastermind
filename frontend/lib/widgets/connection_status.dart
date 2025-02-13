import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectionStatus extends StatelessWidget {
  final Connectivity _connectivity = Connectivity();

  final Widget child;

  final bool enabled;

  ConnectionStatus({
    this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivity.onConnectivityChanged,
      builder: (context, result) {
        if (enabled && result?.data == ConnectivityResult.none ?? true) {
          return Stack(
            children: <Widget>[
              IgnorePointer(
                child: child,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildBanner(context),
              ),
            ],
          );
        } else {
          return child;
        }
      },
    );
  }

  Container _buildBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Keine Internetverbindung!',
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    );
  }
}
