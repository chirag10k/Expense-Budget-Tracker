import 'package:budgetingapp/models/user_model.dart';
import 'package:budgetingapp/screens/home/recent_transaction_screen.dart';
import 'package:budgetingapp/services/auth_service.dart';
import 'package:budgetingapp/services/database_service.dart';
import 'package:budgetingapp/services/push_notification_service.dart';
import 'package:budgetingapp/shared/constants.dart';
import 'package:budgetingapp/shared/loading.dart';
import 'package:budgetingapp/widgets/bottom_control_bar_widget.dart';
import 'package:budgetingapp/widgets/signout_widget.dart';
import 'package:budgetingapp/widgets/top_control_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_page_screen.dart';
import 'account_summary_screen.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  SharedPreferences prefs;
  int _currentPage = 0;
  bool transform = false;
  bool loadList = true;

  final AuthService _authService = AuthService();
  final PushNotificationService _pushNotificationService = PushNotificationService();

  @override
  void initState() {
    super.initState();
    _pushNotificationService.initialise();
  }

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
          double height = MediaQuery.of(context).size.height;
          if(loadList == true){
            _db.getIncomes(user.budgetCycle);
            _db.getExpenses(user.budgetCycle);
            _db.getBudgetCycles();
            loadList = false;
          }
          return Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF004e92),
                          Color(0xFF000428),
                        ],
                      )
                  ),
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width - 20)/2.5, top: 60),
                  child: Column(
                    children: <Widget>[
//                      ListTile(
//                        contentPadding: EdgeInsets.only(left: 20),
//                        leading: Icon(
//                          FontAwesomeIcons.fileExport,
//                          size: 30.0,
//                          color: Colors.white,
//                        ),
//                        title:Text(
//                          'Export',
//                          style: TextStyle(
//                            fontSize: 18.0,
//                            color: Colors.white,
//                          ),
//                        ),
//                        onTap: () => print('Export'),
//                      ),
//                      ListTile(
//                        contentPadding: EdgeInsets.only(left: 60),
//                        leading: Text(
//                          user.nickname,
//                          style: TextStyle(
//                            color: Colors.white,
//                          ),
//                        ),
//                        onTap: () => print('Name'),
//                      ),
//                      ListTile(
//                        contentPadding: EdgeInsets.only(left: 20),
//                        leading: Icon(
//                          Icons.settings,
//                          size: 30.0,
//                          color: Colors.white,
//                        ),
//                        title:Text(
//                          'Settings',
//                          style: TextStyle(
//                            fontSize: 18.0,
//                            color: Colors.white,
//                          ),
//                        ),
//                        onTap: () {
//                          Navigator.push(context, MaterialPageRoute(
//                            builder: (context) => SettingsPage(),
//                          ));
//                        },
//                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 60, top: 50),
                        leading: Icon(
                          Icons.star_border,
                          color: Colors.white,
                        ),
                        title:Text(
                          'Rate Us',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () => print('Rate Us'),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 60),
                        leading: Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        title:Text(
                          'About',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => AboutPage(),
                          ));
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 60),
                        leading: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                        ),
                        title:Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          return SignOut(context);
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(transform == true) {
                      setState(() {
                        transform = false;
                        _currentPage = -1;
                      });
                    }
                  },
                  child: Transform(
                    transform: (transform) ? (Matrix4.identity()..scale(0.5)) : (Matrix4.identity()..scale(1.0)),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: backgroundGradient,
                          padding: const EdgeInsets.only(top: 50.0, left: 10.0, right:  10),
                          child: Container(
                            height: height * 0.35,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => AccountSummaryScreen(),
                                          ));
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(height: 5.0,),
                                            Text(
                                              '₹${user.balance}',
                                              textScaleFactor: MediaQuery.of(context).textScaleFactor * 2,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10.0,),
                                            Text(
                                              'Available Balance',
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Confirm Create New Cycle?'),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        user.budgetCycle += 1;
                                                      });
                                                      print('Cycle Changed to ${user.budgetCycle}');
                                                      _db.updateBudgetData();
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
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(height: 10,),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(40),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                color: Colors.white,
                                                child: Text('${user.budgetCycle}',
                                                  textScaleFactor: MediaQuery.of(context).textScaleFactor * 1.5,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5.0,),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.add_circle_outline, color: Colors.white,),
                                                SizedBox(width: 5,),
                                                Text(
                                                  'Budget Cycle',
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TopControlBar(),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20.0, top: 10.0),
                            width: MediaQuery.of(context).size.width,
                            height: (height > 700) ? height * 0.74 : height * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40.0),
                                topRight: Radius.circular(40.0),
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                    child: ListView(
                                      children:<Widget> [
                                        RecentTransactions(),
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                        bottomControlBar(context),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, top: 60),
                  child: Align(
                    alignment: Alignment.topRight,
                    child:  Container(
                      decoration: profileIconDecoration,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            transform = !transform;
                          });
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Image.network(
                              user.photoUrl,
                              width: 50.0,
                              height: 50.0,
                            )
                        ),
                      ),
                    ),
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
