import 'package:budgetingapp/models/expense_model.dart';
import 'package:budgetingapp/models/user_model.dart';
import 'package:budgetingapp/services/database_service.dart';
import 'package:budgetingapp/shared/list.dart';
import 'package:budgetingapp/shared/loading.dart';
import 'package:budgetingapp/widgets/card_row_details_widget.dart';
import 'package:budgetingapp/widgets/nav_screen_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpensePageScreen extends StatefulWidget {

  int index;

  ExpensePageScreen({this.index});

  @override
  _ExpensePageScreenState createState() => _ExpensePageScreenState(index: index);
}

class _ExpensePageScreenState extends State<ExpensePageScreen> {

  int index;
  DateTime dateTime;

  _ExpensePageScreenState({this.index});

  @override
  Widget build(BuildContext context) {
    if(expList[index].timestamp != null)
      dateTime = expList[index].timestamp.toDate();
    final user1 = Provider.of<User>(context);
    final DatabaseService _db = DatabaseService(user: user1);
    return StreamBuilder(
      stream: _db.userData,
      builder: (context, snapshot){
        User user = snapshot.data;
        _db.user = user;
        if(snapshot.hasData){
          return Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue,
                        Colors.pink,
                      ],
                    ),
                  ),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          backButtonWidget(context, Colors.white),
                          SizedBox(width: 10,),
                          Text(
                            'Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'Rome',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.white,),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: Text('Confirm delete Expense entry?'),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              _db.deleteExpense(expList[index].timestamp, user.budgetCycle, expList[index].amount);
                                              Navigator.pop(context);
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text('Yes'),
                                        ),
                                        FlatButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('No'),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Card(
                        elevation: 20,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 20),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Icon(icons['${expList[index].category}'], color: Colors.red,),
                                  SizedBox(width: 10.0,),
                                  Text(
                                    expList[index].category,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                              SizedBox(height: 30,),
                              cardRowDetails('Category :', 'Expenses', Colors.red),
                              SizedBox(height: 10,),
                              cardRowDetails('Money :', '₹${expList[index].amount}', Colors.red),
                              SizedBox(height: 10,),
                              cardRowDetails('Expense Mode :', '${expList[index].expenseMode}', Colors.red),
                              SizedBox(height: 10,),
                              cardRowDetails('Label :', '${expList[index].textLabel}', Colors.red),
                              SizedBox(height: 10,),
                              cardRowDetails('Date :', '${DateFormat.MMMd().format(dateTime)}', Colors.red),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
