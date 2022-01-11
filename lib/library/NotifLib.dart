
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notify56/main.dart';




class NotifLib{


  // Uygulama arka planda iken bu fonksiyonda handler edilir.
  // Eğer background'da diğer firebase servislerini kullanacaksanız initial etmeyi unutmayın!!

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId!}');
  print("mesaj background'a geldi");
  print(message.notification!.body!.toString());
  print(message.notification!.title!.toString());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

}

//------------------------------------------------------------------------

// Bütün bildirimler bir channel'a atanmalıdır. Aksi takdirde notification uygulamada gözükmez. 

createChannel(){
 AndroidNotificationChannel channel= AndroidNotificationChannel('high_importance_channel',
    'High Importance Notification',
    importance: Importance.high,
    //playSound: true
    ledColor: Colors.red);
    return channel;
}
//------------------------------------------------------------------------

// getWidgetBinding methodu= Firebase'i kullanmak için yerel kodu çağırmamız gerekiyor.
// burada bu işlemi yaptık.

dynamic getWidgetBinding(){

  return WidgetsFlutterBinding.ensureInitialized();

}
//------------------------------------------------------------------------

// Firebase initial etmek için gerekli opsiyonlar var.
// Bunlar apiKey,appId gibi Stringler.
// Firebase'de oluşturduğumuz application'ın gerekli bilgilerini burada veriyoruz.

Future<dynamic> getInitialize (String apiKey,
String appId,String messagingSenderId,String projectId)async{

  var options= FirebaseOptions(apiKey: apiKey,appId: appId,messagingSenderId: messagingSenderId,
  projectId: projectId);
  

  return Firebase.initializeApp(options: options);

}



//------------------------------------------------------------------------

// Android için farklı settingler,ios için farklı settings tanımladık.

createSettings(){
  final android=AndroidInitializationSettings("@mipmap/ic_launcher");
    final iOS=IOSInitializationSettings();
    final settings=InitializationSettings(
      android: android,iOS: iOS
    );
    return settings;
}

//------------------------------------------------------------------------

// Artık oluşturduğum messageListen methodu ile notification'ı local notification ile
//// görebileceğim. 

  Future<void> messageListen(String apiKey,String appId,String messagingSenderId,String projectId)async{

  getWidgetBinding();
  getInitialize(apiKey,appId,messagingSenderId,projectId);

  final settings=createSettings();
  final channel=createChannel();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(settings);

  await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification!;
      AndroidNotification? android = message.notification!.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name, 
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
            ),
          ),
        );
      }
    });
}

  
}















