import 'package:budgetingapp/models/graph_models.dart';
import 'package:budgetingapp/models/user_model.dart';
import 'package:budgetingapp/services/database_service.dart';
import 'package:budgetingapp/shared/loading.dart';
import 'package:budgetingapp/widgets/nav_screen_buttons_widget.dart';
import 'package:budgetingapp/widgets/pie_chart_widget.dart';
import 'package:budgetingapp/widgets/transaction_types_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphBudgetScreen extends StatefulWidget {
  @override
  _GraphBudgetScreenState createState() => _GraphBudgetScreenState();
}

class _GraphBudgetScreenState extends State<GraphBudgetScreen> {

  int selectedGraphMode = 1;

  List<ExpenseItem> eList = List<ExpenseItem>();
  List<IncomeItem> iList = List<IncomeItem>();

  List<charts.Series<ExpenseItem, String>> _expenseSeriesPieData;
  List<charts.Series<IncomeItem, String>> _incomeSeriesPieData;

  _generateIncomeData(iList){
    _incomeSeriesPieData = List<charts.Series<IncomeItem, String>>();
    _incomeSeriesPieData.add(
        charts.Series(
          domainFn: (IncomeItem item, _)=>item.source,
          measureFn: (IncomeItem item, _)=>item.amount,
          id: 'items',
          data: iList,
          labelAccessorFn: (IncomeItem row, _)=>'₹${row.amount}',
        )
    );
  }

  _generateExpenseData(eList){
    _expenseSeriesPieData = List<charts.Series<ExpenseItem, String>>();
    _expenseSeriesPieData.add(
      charts.Series(
        domainFn: (ExpenseItem item, _)=>item.category,
        measureFn: (ExpenseItem item, _)=>item.amount,
        id: 'items',
        data: eList,
        labelAccessorFn: (ExpenseItem row, _)=>'₹${row.amount}',
      )
    );
  }

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
          eList = _db.getExpenseGraphDetails();
          iList = _db.getIncomeGraphDetails();
          _generateIncomeData(iList);
          _generateExpenseData(eList);
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
                        'Graph',
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Rome',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 30.0,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                            child:  TransactionType(iconData: Icons.arrow_downward, type: 'Income', selected: (selectedGraphMode == 1)? true : false,),
                            onTap: () {
                              setState(() {
                                selectedGraphMode = 1;
                                _generateIncomeData(iList);
                              });
                            }
                        ),
                        GestureDetector(
                            child:  TransactionType(iconData: Icons.arrow_upward, type: 'Expense', selected: (selectedGraphMode == 2)? true : false,),
                            onTap: () {
                              setState(() {
                                selectedGraphMode = 2;
                                _generateExpenseData(eList);
                              });
                            }
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  (selectedGraphMode == 1)
                      ? Stack(
                    children: <Widget>[
                      Card(
                        elevation: 10,
                        color: Colors.yellow[700],
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Container(
                          height: 500,
                          width: 600,
                          child: createPieChart(_incomeSeriesPieData),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(top: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:<Widget>[
                            Text(
                              'Income:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              '${user.tIncomeAmount}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10,),

                            IconButton(
                              icon: Icon(FontAwesomeIcons.exchangeAlt),
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: (){
                                setState(() {
                                  selectedGraphMode = 2;
                                  _generateExpenseData(eList);
                                });
                              },
                            ),
                          ]
                        ),
                      ),
                    ],
                  )
                      : SizedBox.shrink(),
                  (selectedGraphMode == 2)
                      ? Stack(
                        children: <Widget>[
                          Card(
                            elevation: 10,
                            color: Colors.yellow[700],
                            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Container(
                              height: 550,
                              width: 600,
                              child: createPieChart(_expenseSeriesPieData),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.only(top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children:<Widget>[
                                  Text(
                                    'Expense:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    '${user.tExpenseAmount}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  IconButton(
                                    icon: Icon(FontAwesomeIcons.exchangeAlt),
                                    color: Colors.white,
                                    iconSize: 30,
                                    onPressed: (){
                                      setState(() {
                                        selectedGraphMode = 1;
                                        _generateIncomeData(iList);
                                      });
                                    },
                                  ),
                                ]
                            ),
                          ),
                        ],
                      )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          );
        }
        else
          return Scaffold(
            body: Loading(),
          );
      },
    );
  }
}


