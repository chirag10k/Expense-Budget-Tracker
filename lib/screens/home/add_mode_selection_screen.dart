import 'package:budgetingapp/screens/home/add_expense_screen.dart';
import 'package:budgetingapp/screens/home/add_money_page.dart';
import 'package:budgetingapp/widgets/nav_screen_buttons_widget.dart';
import 'package:flutter/material.dart';

class AddModeSelectorScreen extends StatefulWidget {
  @override
  _AddModeSelectorScreenState createState() => _AddModeSelectorScreenState();
}

class _AddModeSelectorScreenState extends State<AddModeSelectorScreen> {

  String selectedMode;
  int flag = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      backButtonWidget(context, Colors.black),
                      SizedBox(width: 20,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.yellow[700],
                          child: DropdownButton<String>(
                            items: [
                              DropdownMenuItem(
                                child: Text('Expenses'),
                                value: 'expenses',
                              ),
                              DropdownMenuItem(
                                child: Text('Income / Money'),
                                value: 'income',
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedMode = value;
                                if(selectedMode == 'expenses')
                                  flag = 0;
                                else
                                  flag = 1;
                              });
                            },
                            hint: Text('Income | Expense?', style: TextStyle(color: Colors.black),),
                            value: selectedMode,
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
                ),
                SizedBox(height: 20,),
                Expanded(
                  child: PageView(
                    children: <Widget>[
                      (flag == 0)
                          ? AddExpensePage()
                          : (flag == 1) ? AddMoneyPage()
                          :Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                        children:<Widget>[ Text(
                            'Select Income or Expense to Add!',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25
                            ),
                        ),]
                      ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}
