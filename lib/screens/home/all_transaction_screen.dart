import 'package:budgetingapp/models/user_model.dart';
import 'package:budgetingapp/services/database_service.dart';
import 'package:budgetingapp/shared/loading.dart';
import 'package:budgetingapp/widgets/build_expense_tiles_widget.dart';
import 'package:budgetingapp/widgets/build_income_tiles_widget.dart';
import 'package:budgetingapp/widgets/nav_screen_buttons_widget.dart';
import 'package:budgetingapp/widgets/transaction_types_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllTransactionsScreen extends StatefulWidget {
  @override
  _AllTransactionsScreenState createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  int selectedMode = 0;
  bool load = true;

  @override
  Widget build(BuildContext context) {
    User user1 = Provider.of<User>(context);
    DatabaseService _db = DatabaseService(user: user1);
    return StreamBuilder(
      stream: _db.userData,
      builder: (context, snapshot){
        User user = snapshot.data;
        _db.user = user;
        if(snapshot.hasData){
          _db.getExpenses(user.budgetCycle);
          _db.getIncomes(user.budgetCycle);
          return Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.blue[50],
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      backButtonWidget(context, Colors.blue[800]),
                      SizedBox(width: 15.0,),
                      Text(
                        'All Transactions',
                        textScaleFactor: MediaQuery.of(context).textScaleFactor * 2,
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rome'
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    height: 30.0,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          child:  TransactionType(iconData: null, type: 'All', selected: (selectedMode == 0)? true : false,),
                          onTap: () {
                            setState(() {
                              selectedMode = 0;
                            });
                          }
                        ),
                        GestureDetector(
                          child:  TransactionType(iconData: Icons.arrow_downward, type: 'Income', selected: (selectedMode == 1)? true : false,),
                            onTap: () {
                              setState(() {
                                selectedMode = 1;
                              });
                            }
                        ),
                        GestureDetector(
                          child:  TransactionType(iconData: Icons.arrow_upward, type: 'Expense', selected: (selectedMode == 2)? true : false,),
                            onTap: () {
                              setState(() {
                                selectedMode = 2;
                              });
                            }
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  (selectedMode == 0) ?
                  Column(
                    children: <Widget>[
                      BuildIncomeTiles(itemCount: 0, all: true,),
                      BuildExpenseTiles(itemCount: 0, all: true,),
                    ],
                  )
                      : SizedBox.shrink(),
                  (selectedMode == 1) ?
                  BuildIncomeTiles(itemCount: 0, all: true)
                      : SizedBox.shrink(),
                  (selectedMode == 2)?
                  BuildExpenseTiles(itemCount: 0, all: true,)
                      :SizedBox.shrink(),
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