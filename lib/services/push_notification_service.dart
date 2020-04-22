import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;

class PushNotificationService{
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async{
    if(Platform.isIOS){
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

//    _fcm.getToken().then((deviceToken){
//      print('Device Token: $deviceToken');
//    });

    _fcm.configure(
      //Called when the app is in Foreground and we receive a push notification
      onMessage: (Map<String, dynamic> message) async{
        print('onMessage: $message');
      },
      //Called when the app has been closed completely and its opened from the
      //push notification directly
      onLaunch:  (Map<String, dynamic> message) async{
        print('onMessage: $message');
      },
      //Called when the app is in background and is opened from the
      //push notification directly
      onResume:  (Map<String, dynamic> message) async{
        print('onMessage: $message');
      },
    );
  }
}