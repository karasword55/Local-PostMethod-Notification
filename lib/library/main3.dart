
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notify56/RestApi/Api.dart';
import 'package:notify56/library/NotifLib.dart';
import 'package:notify56/utilities/utility.dart';


getToken() async{
    String? token= await FirebaseMessaging.instance.getToken();
    debugPrint(token);
  }

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getToken();
  
  runApp(MyApp2());
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
    //getToken();
  }

  @override
  Widget build(BuildContext context) {
    int a=5;
    
    setState((){
      
      NotifLib lib=NotifLib();
      lib.messageListen(utility.apiKey,
      utility.appId,
      utility.messagingSenderId,
      utility.projectId);      
    });
    

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
                //pushNotifyWithApi();
                Api restApi=Api();
                restApi.sendFcm('main3 title686', 'main3 body676',
                 'dlnEGunyRTumm6nwpyLdIm:APA91bGTbb92SvEVY_9nY80OXiwq6hOG-xK51vNaqYrFbbM7WyXAIov2sc1N3J-QTVPmAOtnDjXVh6leqE2lmi0oqIHTi4vNyBmkK55jz8LRvVudO1L-FeoAch29lHzx9D4eH9zPIdXU');
              },
              child: Text("send notif with restApi"),
            ),
            
            
          ],
          
        ),
      ),

    );
  }  
}

