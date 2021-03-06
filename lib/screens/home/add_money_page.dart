import 'package:budgetingapp/models/user_model.dart';
import 'package:budgetingapp/services/database_service.dart';
import 'package:budgetingapp/shared/constants.dart';
import 'package:budgetingapp/shared/list.dart';
import 'package:budgetingapp/shared/loading.dart';
import 'package:budgetingapp/widgets/nav_screen_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMoneyPage extends StatefulWidget {
  @override
  _AddMoneyPageState createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {

  final _formKey = GlobalKey<FormState>();

  String selectedIncomeMode = addIncomeMode[0];
  int amount;
  String addedSourceTitle;
  String source;

  @override
  Widget build(BuildContext context) {
    final User user1 = Provider.of<User>(context);
    final DatabaseService _db = DatabaseService(user: user1);
    return StreamBuilder(
      stream: _db.userData,
      builder: (context, snapshot){
        User user = snapshot.data;
        _db.user = user;
        if(snapshot.hasData){
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: backgroundGradient,
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: addButtonWidget(Colors.white),
                        onTap: (){
                          if(_formKey.currentState.validate()){
                            if(selectedIncomeMode == addIncomeMode[1])
                              selectedIncomeMode = (addedSourceTitle == null) ? 'Others' : addedSourceTitle;
                            _db.addIncome(amount, selectedIncomeMode);
                            print('Income Added');
                            showDialog(context: context,builder: (context){
                              return AlertDialog(
                                title: Text("Income Added!"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      'OK',
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } ,
                                  ),
                                ],
                              );
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 50.0,),
                  incomeSourceSelector(),
                  SizedBox(height: 30.0,),
                  Container(
                    child: incomeDetailsForm(context),
                  ),
                ],
              ),
            ),
          );
        }
        else{
          return Scaffold(body: Loading());
        }
      },
    );
  }

  Widget incomeDetailsForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Amount Field
          Text(
            '* Amount',
            style: formFieldTitleTextStyle,
          ),
          SizedBox(height: 15.0,),
          TextFormField(
              keyboardType: TextInputType.number,
              decoration: formFieldDecoration,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
              onChanged: (val) {
                amount = int.parse(val);
              },
              validator: (val){
                if(val.isEmpty)
                  return 'Please enter an amount';
                else if(val.contains('-') || val.contains(' ') || val.contains(','))
                  return 'Invalid Amount';
                else
                  return null;
              }
          ),
          SizedBox(height: 15.0,),
          //Custom Source Title Field
          (selectedIncomeMode == addIncomeMode[1])
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15.0,),
              Text(
                'Source Title',
                style: formFieldTitleTextStyle.copyWith(fontSize: 40.0),
              ),
              TextFormField(
                decoration: formFieldDecoration,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
                onChanged: (val) {
                  addedSourceTitle = val;
                },
              ),
              SizedBox(height: 15.0,)
            ],
          )
              : SizedBox(height: 15.0,),
        ],
      ),
    );
  }
  
  Widget incomeSourceSelector() {
    List<Widget> buildIncomeModeChip() {
      List<Widget> incomesource = addIncomeMode.map((title) {
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: (title.compareTo(selectedIncomeMode) == 0) ? Colors.white : Colors.black,
          child: Text(
            title,
            style: TextStyle(
              color: (title.compareTo(selectedIncomeMode) == 0) ? Colors.black : Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Rome',
            ),
          ),
          onPressed: () {
            setState(() {
              selectedIncomeMode = title;
            });
          },
        );
      }).toList();
      return incomesource;
    }
    return Wrap(
      spacing: 20,
      alignment: WrapAlignment.spaceAround,
      children: buildIncomeModeChip(),
    );
  }
}
