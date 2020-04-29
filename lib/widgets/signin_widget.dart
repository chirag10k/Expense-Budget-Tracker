import 'package:budgetingapp/services/auth_service.dart';
import 'package:budgetingapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _authService = AuthService();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        /*loading ? Loading() :*/ Container(
//          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MaterialButton(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
//            height: 40.0,
            minWidth: MediaQuery.of(context).size.width,
            color: Colors.white,
            elevation: 5.0,
            onPressed: () async {
//              setState(() => loading = true);
              dynamic result = await _authService.signInWithGoogle();
//              if(result == null){
//                setState(() {
//                  loading = false;
//                });
//              }
              return result;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Icon(
                    FontAwesomeIcons.google,
                    color: Colors.green,
                    size: 25.0,
                  ),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Center(
                    child: Text(
                      'Sign In With Google',
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
