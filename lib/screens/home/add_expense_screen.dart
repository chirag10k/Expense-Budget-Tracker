import 'package:budgetingapp/models/user_model.dart';
import 'package:budgetingapp/services/database_service.dart';
import 'package:budgetingapp/shared/constants.dart';
import 'package:budgetingapp/shared/list.dart';
import 'package:budgetingapp/shared/loading.dart';
import 'package:budgetingapp/widgets/nav_screen_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {

  final _formKey = GlobalKey<FormState>();

  String selectedCategory = '';
  String selectedExpenseMode = addExpenseMode[1];
  String addedCategoryTitle = '';
  int amount;
  String textLabel;

  @override
  Widget build(BuildContext context) {
    final user1 = Provider.of<User>(context);
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
                            if(selectedCategory.isEmpty)
                              selectedCategory = 'Misc';
                            _db.addExpense(amount, selectedExpenseMode, textLabel, selectedCategory);
                            print('Expense Added');
                            showDialog(context: context,builder: (context){
                              return AlertDialog(
                                title: Text("Expense Added!"),
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
                  SizedBox(height: 10.0,),
                  expenseModeSelector(),
                  SizedBox(height: 20.0,),
                  Container(
                    child: expenseDetailsForm(context),
                  ),
                ],
              ),
            ),
          );
        }else{
          return Scaffold(body: Loading());
        }
      },
    );
  }

  Widget expenseDetailsForm(BuildContext context) {
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
          //Label Field
          Text(
            (selectedExpenseMode == addExpenseMode[1]) ? '* Text Label' : '* Person',
            style: formFieldTitleTextStyle,
          ),
          SizedBox(height: 15.0,),
          TextFormField(
            decoration: formFieldDecoration,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            ),
            onChanged: (val) {
              textLabel = val;
            } ,
            validator: (val){
              if(val.isEmpty && selectedExpenseMode != addExpenseMode[1])
                return 'Empty Field not Allowed';
              else
                return null;
            }
          ),

          (selectedExpenseMode == addExpenseMode[1])
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15.0,),
              //Category Title Field
              Text(
                'Add Custom Category Title',
                style: formFieldTitleTextStyle.copyWith(fontSize: 30.0),
              ),
              TextFormField(
                decoration: formFieldDecoration,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
                onChanged: (val) {
                  addedCategoryTitle = val;
                },
              ),
              SizedBox(height: 15.0,),
              //Widget for building category chips
              expenseCategorySelector(),
              SizedBox(height: 15.0,)
            ],
          )
              : SizedBox(height: 15.0,),
        ],
      ),
    );
  }

  Widget expenseModeSelector() {

    List<Widget> buildExpenseModeChip() {
      List<Widget> expensemode = addExpenseMode.map((title) {
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: (title.compareTo(selectedExpenseMode) == 0) ? Colors.white : Colors.black,
          child: Text(
            title,
            style: TextStyle(
              color: (title.compareTo(selectedExpenseMode) == 0) ? Colors.black : Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Rome',
            ),
          ),
          onPressed: () {
            setState(() {
              selectedExpenseMode = title;
            });
          },
        );
      }).toList();
      return expensemode;
    }
    return Wrap(
      spacing: 20,
      alignment: WrapAlignment.spaceAround,
      children: buildExpenseModeChip(),
    );
  }

  Widget expenseCategorySelector() {

    List<Widget> buildCategoryChip() {
      Widget addCategoryWidget(){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: addCategoryChipDecoration,
          child: InkWell(
            child: Text(
              'Add Category',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            onTap: () {
              if(addedCategoryTitle != '') {
                setState(() {
                  expenseCategories.add(addedCategoryTitle);
                });
              }
              else
                print('touch wasted');
            },
          ),
        );
      }

      List<Widget> category = expenseCategories.map((title) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: (title.compareTo(selectedCategory) == 0) ? LinearGradient(
              colors: [
                Colors.lightGreen,
                Colors.pinkAccent,
              ],
            ) : LinearGradient(colors: [Colors.blue, Colors.indigoAccent])
          ),
          child: InkWell(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            onTap: () {
              setState(() {
                selectedCategory = title;
              });
            },
          ),
        );
      }).toList();
      category.insert(0, addCategoryWidget());
      return category;
    }

    return Wrap(
      spacing: 20,
      runSpacing: 10.0,
      alignment: WrapAlignment.start,
      children: buildCategoryChip(),
    );
  }
}