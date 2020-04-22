import 'package:budgetingapp/models/reminder_model.dart';
import 'package:budgetingapp/models/user_model.dart';
import 'package:budgetingapp/services/database_service.dart';
import 'package:budgetingapp/shared/loading.dart';
import 'package:budgetingapp/widgets/nav_screen_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  String _time;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     didUpdateWidget(SettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    final user1 = Provider.of<User>(context);
    final DatabaseService _db = DatabaseService(user: user1);
    return StreamBuilder(
      stream: _db.userData,
        builder:(context, snapshot){
          User user = snapshot.data;
          _db.user = user;
          _db.getReminders();
          if (snapshot.hasData) {
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
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                          child: Row(
                            children: <Widget>[
                              backButtonWidget(context, Colors.white),
                              SizedBox(width: 20,),
                              Container(
                                alignment: Alignment.center,
                                height: 90,
                                child: Text(
                                  'Smart Reminder',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Rome',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: IconButton(
                            icon: Icon(Icons.add_circle,),
                            color: Colors.white,
                            iconSize: 50,
                            onPressed: () async{
                              final TimeOfDay picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if(picked != null) {
                                print('Time Seleced: $picked');
                                setState(() {
                                  _time = picked.format(context);
                                  if (_time != null) {
                                    _db.setReminders(_time);
                                    _db.getReminders();
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: MediaQuery.of(context).size.height * 0.666,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: reminderList.length,
                            itemBuilder: (context, index){
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  height: 90,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue[50],
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Time: ',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 30,
                                            letterSpacing: 5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Rome'
                                        ),
                                      ),
                                      Text(
                                        reminderList[index].time,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                          letterSpacing: 5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Rome'
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          size: 25,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context){
                                              return AlertDialog(
                                                title: Text('Confirm Delete Reminder?'),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {
                                                     setState(() {
                                                       _db.deleteReminder(reminderList[index].time);
                                                       _db.getReminders();
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
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ]
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
