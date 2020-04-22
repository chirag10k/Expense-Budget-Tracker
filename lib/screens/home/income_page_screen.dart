import 'package:budgetingapp/models/income_model.dart';
import 'package:budgetingapp/models/user_model.dart';
import 'package:budgetingapp/services/database_service.dart';
import 'package:budgetingapp/shared/loading.dart';
import 'package:budgetingapp/widgets/card_row_details_widget.dart';
import 'package:budgetingapp/widgets/nav_screen_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IncomePageScreen extends StatefulWidget {

  int index;

  IncomePageScreen({this.index});

  @override
  _IncomePageScreenState createState() => _IncomePageScreenState(index: index);
}

class _IncomePageScreenState extends State<IncomePageScreen> {


  int index;
  DateTime dateTime;

  _IncomePageScreenState({this.index});

  @override
  Widget build(BuildContext context) {
    if(incomeList[index].timestamp != null)
      dateTime = incomeList[index].timestamp.toDate();
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
                  decoration:  BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF50C9C3),
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
                                      title: Text('Confirm delete Income entry?'),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              _db.deleteIncome(incomeList[index].timestamp, user.budgetCycle, incomeList[index].amount);
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
                        color: Colors.blue[50],
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
                                  Icon(FontAwesomeIcons.rupeeSign, color: Colors.green,),
                                  SizedBox(width: 10.0,),
                                  Text(
                                    incomeList[index].source,
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
                              cardRowDetails('Category :', 'Income', Colors.green),
                              SizedBox(height: 10,),
                              cardRowDetails('Money :', '₹${incomeList[index].amount}', Colors.green),
                              SizedBox(height: 10,),
                              cardRowDetails('Date :', '${DateFormat.MMMd().format(dateTime)}', Colors.green),
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