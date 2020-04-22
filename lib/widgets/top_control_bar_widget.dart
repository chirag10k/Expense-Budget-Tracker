import 'package:budgetingapp/screens/home/graph_budget_screen.dart';
import 'package:budgetingapp/screens/home/history_screen.dart';
import 'package:budgetingapp/shared/list.dart';
import 'package:flutter/material.dart';

class TopControlBar extends StatefulWidget {
  @override
  _TopControlBarState createState() => _TopControlBarState();
}

class _TopControlBarState extends State<TopControlBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 20,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)
              ),
              child: IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => GraphBudgetScreen(),
                  ));
                },
                icon: iconList[1].data,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              iconList[1].title,
              textScaleFactor: MediaQuery.of(context).textScaleFactor * 0.9,
              style: TextStyle(color: Colors.white,),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(width: 20,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)
              ),
              child: IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => HistoryScreen(),
                  ));
                },
                icon: iconList[0].data,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              iconList[0].title,
              textScaleFactor: MediaQuery.of(context).textScaleFactor * 0.9,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
//        Spacer(),
//        Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Container(
//              decoration: BoxDecoration(
//                  color: Colors.white,
//                  borderRadius: BorderRadius.circular(15.0)
//              ),
//              child: IconButton(
//                onPressed: (){
//                  Navigator.pop(context);
//                  Navigator.push(context, MaterialPageRoute(
//                    builder: (context)=> HomeScreen(),
//                  ));
//                },
//                icon: Icon(Icons.refresh),
//                color: Colors.black,
//              ),
//            ),
//            SizedBox(height: 5.0,),
//            Text('Refresh', style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
//          ],
//        ),
//        SizedBox(width: 20,),
      ],
    );
  }
}
