import 'package:budgetingapp/models/user_model.dart';
import 'package:budgetingapp/services/database_service.dart';
import 'package:budgetingapp/shared/list.dart';
import 'package:budgetingapp/shared/loading.dart';
import 'package:budgetingapp/widgets/build_expense_tiles_widget.dart';
import 'package:budgetingapp/widgets/build_income_tiles_widget.dart';
import 'package:budgetingapp/widgets/nav_screen_buttons_widget.dart';
import 'package:budgetingapp/widgets/transaction_types_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  String selectedCycle;
  int selectedMode = -1;

  @override
  void initState() {
    selectedCycle = null;
    super.initState();
  }

  List<DropdownMenuItem<String>> budgetCycleListBuilder(){
    return budgetCycleList.map((String title){
      return DropdownMenuItem<String>(
        value: title,
        child: Text(title),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    User user1 = Provider.of<User>(context);
    DatabaseService _db = DatabaseService(user: user1);
    return StreamBuilder(
      stream: _db.userData,
      builder: (context, snapshot) {
        User user = snapshot.data;
        _db.user = user;
        if (snapshot.hasData) {
          _db.getBudgetCycles();
          budgetCycleList.sort((a, b)=> a.length.compareTo(b.length));
          return Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.blue[50],
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      backButtonWidget(context, Colors.blue[800]),
                      SizedBox(width: 15.0,),
                      Text(
                        'History',
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Rome',
                        ),
                      ),
                      Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.yellow[700],
                          child: DropdownButton<String>(
                            items: budgetCycleListBuilder(),
                            onChanged: (value) {
                              setState(() {
                                selectedCycle = value;
                                _db.getExpenses(int.parse(selectedCycle));
                                _db.getIncomes(int.parse(selectedCycle));
                                selectedMode = -1;
                              });
                            },
                            hint: Text('Budget Cycle?', style: TextStyle(color: Colors.black),),
                            value: selectedCycle,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            iconSize: 35,
                          ),
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
                      BuildIncomeTiles(itemCount: 0, all: true, flag: 0,),
                      BuildExpenseTiles(itemCount: 0, all: true, flag: 0,),
                    ],
                  )
                      : SizedBox.shrink(),
                  (selectedMode == 1) ?
                  BuildIncomeTiles(itemCount: 0, all: true, flag: 0,)
                      : SizedBox.shrink(),
                  (selectedMode == 2)?
                  BuildExpenseTiles(itemCount: 0, all: true, flag: 0,)
                      :SizedBox.shrink(),
                  (selectedMode == -1)?
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.indigo,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          'Select Mode ↑',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                      :SizedBox.shrink(),
                ],
              ),
            ),
          );
        }
        else {
          return Scaffold(
            body: Loading(),
          );
        }
      }
    );
  }
}
