import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendyol/pages/logo_screen/logo_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trendyol/services/notification_service/notifications.dart';

void main() async {
  await init();
  runApp(const Klimar());
}

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

Locale? locale;

class Klimar extends StatefulWidget {
  const Klimar({Key? key}) : super(key: key);

  @override
  State<Klimar> createState() => _KlimarState();
  static _KlimarState? of(BuildContext context) =>
      context.findAncestorStateOfType<_KlimarState>();
}

class _KlimarState extends State<Klimar> {
  void setLocale(Locale value) {
    setState(() {
      locale = value;
    });
  }

  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';
  ios_push() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    ios_push();
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications(context);
    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    super.initState();
  }

  _changeData(String msg) => setState(() => notificationData = msg);
  _changeBody(String msg) => setState(() => notificationBody = msg);
  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale("ar", "AE"),
      ],
      locale: Locale("ar", "AE"),
      debugShowCheckedModeBanner: false,
      title: 'Klimar',
      theme: ThemeData(
        textTheme: GoogleFonts.tajawalTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
      ),
      home: LogoScreen(),
    );
  }
}
