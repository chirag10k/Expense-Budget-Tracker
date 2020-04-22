import 'package:budgetingapp/models/user_model.dart';
import 'package:budgetingapp/screens/home/all_transaction_screen.dart';
import 'package:budgetingapp/services/database_service.dart';
import 'package:budgetingapp/shared/constants.dart';
import 'package:budgetingapp/shared/loading.dart';
import 'package:budgetingapp/widgets/build_expense_tiles_widget.dart';
import 'package:budgetingapp/widgets/build_income_tiles_widget.dart';
import 'package:budgetingapp/widgets/transaction_types_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentTransactions extends StatefulWidget {
  @override
  _RecentTransactionsState createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {


  int selectedMode = -1;
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
         return Column(
           children: <Widget>[
             Container(
               child: Row(
                 mainAxisSize: MainAxisSize.max,
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   Container(
                     width: (MediaQuery.of(context).size.width - 45) * .7,
                     child: Text(
                       'Recent Transactions',
                       style: TextStyle(
                         color: Colors.blue[900],
                         fontSize: 25.0,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                   SizedBox(width: 5,),
                   Container(
                     width: (MediaQuery.of(context).size.width - 45) * .3,
                     child: FlatButton(
                       shape: chipShape,
                       color: Colors.black,
                       child: Text(
                         'See All',
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 22.0,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       onPressed: (){
                         Navigator.push(context, MaterialPageRoute(
                           builder: (context) => AllTransactionsScreen(),
                         ));
                         setState(() => selectedMode = -1);
                       },
                     ),
                   ),
                 ],
               ),
             ),
             SizedBox(height: 10.0,),
             Container(
               height: 30.0,
               width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                        child:  TransactionType(iconData: Icons.account_balance_wallet, type: 'All', selected: (selectedMode == 0)? true : false,),
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
             (selectedMode == 0) ?
             Column(
               children: <Widget>[
                 BuildIncomeTiles(itemCount: 3, all: false,),
                 BuildExpenseTiles(itemCount: 3, all: false,),
               ],
             )
                 : SizedBox.shrink(),
             (selectedMode == 1) ?
             BuildIncomeTiles(itemCount: 6, all: false,)
                 : SizedBox.shrink(),
             (selectedMode == 2)?
             BuildExpenseTiles(itemCount: 6, all: false,)
                 :SizedBox.shrink(),
           ],
         );
       }
       else{
         return Center(
           child: Loading(),
         );
       }
     },
   );
  }
}