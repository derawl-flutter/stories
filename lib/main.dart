import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/home.dart';
import 'screens/search.dart';
import 'screens/details.dart';
import 'services/http_server.dart';
import 'screens/st.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'screens/account.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'services/http_server.dart';
import 'services/saved_stories_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'services/load_stories_providers.dart';

AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
    'stories',
    'storiesNotification'
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessageBackgroundHanler(RemoteMessage message) async{
  await Firebase.initializeApp();
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final applicationDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(applicationDocumentDir.path);
  await Hive.openBox('savedStories');
  var box = Hive.box('savedStories');
  if (box.get('saved_stories') == null){
    box.put('saved_stories', []);
  };
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessageBackgroundHanler);

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    sound: true,
    badge: true,
    alert: true
  );

  await MobileAds.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SavedBooks()),
        ChangeNotifierProvider(create: (_) => LoadStories()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received');
      var remoteNotification = message.notification;
      var androidNotification = message.notification?.android;
      if(remoteNotification != null && androidNotification != null){
        flutterLocalNotificationsPlugin.show(
            remoteNotification.hashCode,
            remoteNotification.title,
            remoteNotification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                androidNotificationChannel.id,
                androidNotificationChannel.name,
                color: Colors.blue,
                importance: Importance.high,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              )
            )
        );
      }


    });

    FirebaseMessaging.onMessageOpenedApp.listen((message){
      print('Message received');
      var remoteNotification = message.notification;
      var androidNotification = message.notification?.android;
      if(remoteNotification != null && androidNotification != null){
        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: Text(remoteNotification.title.toString(),),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(remoteNotification.body.toString())
                ],
              ),
            ),
          );
        });
      }
    });
  }
  @override
  Widget build(BuildContext context){
    context.read<SavedBooks>().getStories();
    context.read<LoadStories>().LoadStory();
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute:  MyHomePage.route,
      routes: {
        MyHomePage.route: (context) => MyHomePage(),
        SearchPage2.route: (context) => SearchPage2(),
        SavedStories.route: (context) => SavedStories()

      },
    );
  }
}

