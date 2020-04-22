import 'package:budgetingapp/models/user_model.dart';
import 'package:budgetingapp/services/database_service.dart';
import 'package:budgetingapp/shared/constants.dart';
import 'package:budgetingapp/shared/loading.dart';
import 'package:budgetingapp/widgets/nav_screen_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AccountSummaryScreen extends StatefulWidget {
  @override
  _AccountSummaryScreenState createState() => _AccountSummaryScreenState();
}

class _AccountSummaryScreenState extends State<AccountSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    User user1 = Provider.of<User>(context);
    final DatabaseService _db = DatabaseService(user: user1);
    return StreamBuilder(
      stream: _db.userData,
      builder: (context, snapshot){
        User user = snapshot.data;
        _db.user = user;
        if(snapshot.hasData){
          return Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.blue[50],
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      backButtonWidget(context, Colors.blue[800]),
                      SizedBox(width: 10.0,),
                      Text(
                        'Account Summary',
                        textScaleFactor: MediaQuery.of(context).textScaleFactor * 2,
                        style: TextStyle(
                            color: Colors.blue[900],
//                            fontSize: 38.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rome'
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    height: 80.0,
                    decoration: addExpenseButtonDecoration.copyWith(color: Colors.blueGrey[800]),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.rupeeSign,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 5.0,),
                        Text(
                          'Total Balance:',
                          textScaleFactor: MediaQuery.of(context).textScaleFactor * 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Rome',
                          ),
                        ),
                        Spacer(),
                        Text(
                          '₹${user.balance}',
                          textScaleFactor: MediaQuery.of(context).textScaleFactor * 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Rome',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    height: 80.0,
                    decoration: addExpenseButtonDecoration.copyWith(color: Colors.blueGrey[800]),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.plusCircle,
                          color: Colors.green,
                        ),
                        SizedBox(width: 5.0,),
                        Text(
                          'Total Income:',
                          textScaleFactor: MediaQuery.of(context).textScaleFactor * 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Rome',
                          ),
                        ),
                        Spacer(),
                        Text(
                          '₹${user.tIncomeAmount}',
                          textScaleFactor: MediaQuery.of(context).textScaleFactor * 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Rome',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    height: 80.0,
                    decoration: addExpenseButtonDecoration.copyWith(color: Colors.blueGrey[800]),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.minusCircle,
                          color: Colors.red,
                        ),
                        SizedBox(width: 5.0,),
                        Text(
                          'Total Expense:',
                          textScaleFactor: MediaQuery.of(context).textScaleFactor * 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Rome',
                          ),
                        ),
                        Spacer(),
                        Text(
                          '₹${user.tExpenseAmount}',
                          textScaleFactor: MediaQuery.of(context).textScaleFactor * 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Rome',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                ],
              ),
            ),
          );
        }
        else{
          return Scaffold(
            body: Loading(),
          );
        }
      },
    );
  }
}
