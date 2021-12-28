import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'RestApi/Api.dart';

// 
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print("mesaj background'a geldi");
  print(message.notification!.body.toString());
  print(message.notification!.title.toString());
}

// AndroidNotificationChannel sınıfından oluşturduğumuz nesne ile gelen bildirimin sesini,
// yüksekliğini,önem sırası,kilit ekranında gözüküp gözükmeyeceği,ekran ışığın açıp açmayacağı
// beni rahatsız etme özelliğinin olup olmayacağını bize sunar.Yani bunları istediğimiz
//şekilde ayarlayabiliriz.
//Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

// Uygulama hangi platformda çalışıyorsa onu geri döner. Android-IOS-noPlatform gibi.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;



Future<void> main() async {
  // firebase App initialize
  /*WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();*/

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBevhHSmRq9CwGraQJ1rpAvi5CK1OKn2nE',
      appId: '1:664060846765:android:5cfaa4b1fbe6b4642c9c24',
      messagingSenderId: '664060846765',
      projectId: 'notify56-69900',
    ),
  );

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel= const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notification',
    importance: Importance.high,
    //playSound: true
    ledColor: Colors.red
  );
  
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
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

  runApp(MyApp2());
}

getSettings() {
  
  final android=AndroidInitializationSettings("@mipmap/ic_launcher");
    final iOS=IOSInitializationSettings();
    final settings=InitializationSettings(
      android: android,iOS: iOS
    );


     flutterLocalNotificationsPlugin.initialize(settings);

}

pushNotifyWithApi()async{
  Api api=Api();
  api.sendFcm('titleHttp', 'bodyHttp', 'dlnEGunyRTumm6nwpyLdIm:APA91bGTbb92SvEVY_9nY80OXiwq6hOG-xK51vNaqYrFbbM7WyXAIov2sc1N3J-QTVPmAOtnDjXVh6leqE2lmi0oqIHTi4vNyBmkK55jz8LRvVudO1L-FeoAch29lHzx9D4eH9zPIdXU');

}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'title',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    
    

     
    //getSettings();
    final android=AndroidInitializationSettings("@mipmap/ic_launcher");
    final iOS=IOSInitializationSettings();
    final settings=InitializationSettings(
      android: android,iOS: iOS
    );


     flutterLocalNotificationsPlugin.initialize(settings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
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

  


  @override
  Widget build(BuildContext context) {
    final android=AndroidInitializationSettings("@mipmap/ic_launcher");
    final iOS=IOSInitializationSettings();
    final settings=InitializationSettings(
      android: android,iOS: iOS
    );


     flutterLocalNotificationsPlugin.initialize(settings);
     
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
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
    //pushNotifyWithApi();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: (){
                pushNotifyWithApi();
              },
              child: Text("push notif"),
            ),
            
          ],
          

        ),
      ),

    );
  }

  getToken() async{
    String? token= await FirebaseMessaging.instance.getToken();
    print(token);
  }
}