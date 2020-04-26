import 'package:budgetingapp/enums/connectivity_status.dart';
import 'package:budgetingapp/screens/authentication/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../offline_screen.dart';

class AuthenticateScreen extends StatefulWidget {
  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  @override
  Widget build(BuildContext context){
//    final connectionStatus = Provider.of<ConnectivityStatus>(context);
    return OnboardingScreen();
  }
}
