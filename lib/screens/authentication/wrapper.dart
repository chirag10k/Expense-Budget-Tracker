import 'package:budgetingapp/enums/connectivity_status.dart';
import 'package:budgetingapp/models/user_model.dart';
import 'package:budgetingapp/screens/authentication/authenticate_screen.dart';
import 'package:budgetingapp/screens/home/home_screen.dart';
import 'package:budgetingapp/screens/offline_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final connectionStatus = Provider.of<ConnectivityStatus>(context);
    //return either Home or Authenticate Screen
    return (connectionStatus == ConnectivityStatus.Offline)
        ? OfflineScreen()
          : ((user != null) ? HomeScreen() : AuthenticateScreen());
  }
}
