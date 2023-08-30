import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tour_guide_admin/generated/locales.g.dart';
import 'package:tour_guide_admin/helpers/helpers.dart';
import 'package:tour_guide_admin/views/mobile/screens/screen_admin_mobile_splash.dart';
import 'package:tour_guide_admin/views/screens/screen_login.dart';
import 'package:tour_guide_admin/widgets/custom_error.dart';

import 'helpers/fcm.dart';
import 'helpers/helpers.dart';
/*Created Project "tour_guide_admin" by MicroProgramers - https://microprogramers.org*/


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 2));
  colorConfig();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

void colorConfig() {
  appPrimaryColor = MaterialColor(
  0xFFFE543D,
    const <int, Color>{
      50: const Color(0xFFFE543D),
      100: const Color(0xFFFE543D),
      200: const Color(0xFFFE543D),
      300: const Color(0xFFFE543D),
      400: const Color(0xFFFE543D),
      500: const Color(0xFFFE543D),
      600: const Color(0xFFFE543D),
      700: const Color(0xFFFE543D),
      800: const Color(0xFFFE543D),
      900: const Color(0xFFFE543D),
    },
  );
  appBoxShadow = [BoxShadow(blurRadius: 18, color: Color(0x414D5678))];
  buttonColor = const Color(0xFFFE543D);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    setupInteractedMessage();
    setupNotificationChannel();
    super.initState();
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {}
  }


  void setupNotificationChannel() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
        null/*onSelectNotification(payload)*/);
    await flutterLocalNotificationsPlugin.initialize(InitializationSettings(
        android: settingsAndroid,
        iOS: settingsIOS
    ));

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? iOS = message.notification?.apple;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                enableVibration: true,
                // importance: Importance.max,
                // priority: Priority.high,
                // ongoing: true,
                // autoCancel: false,
                // other properties...
              ),
            ));

        // showOngoingNotification(flutterLocalNotificationsPlugin, title: notification.title ?? "", body: notification.body ?? "");
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return GetMaterialApp(
          home: ScreenAdminMobileSplash(),
          locale: Locale('en', 'US'),
          translationsKeys: AppTranslation.translations,
          debugShowCheckedModeBanner: false,
          title: "$appName",
          theme: ThemeData(
            fontFamily: 'SFProDisplay',
            primarySwatch: appPrimaryColor,
            checkboxTheme: CheckboxThemeData(
              checkColor: MaterialStateProperty.all(Colors.white),
              fillColor: MaterialStateProperty.all(appPrimaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: BorderSide(color: Color(0xff585858), width: 1),
            ),
            appBarTheme: AppBarTheme(
              color: Colors.white,
              elevation: 1,
              titleTextStyle: normal_h1Style_bold.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "SFProDisplay"),
              centerTitle: false,
              systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
              iconTheme: IconThemeData(color: Colors.black),
            ),
            dividerColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
          ),
          builder: (context, widget) {
            ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
              return CustomError(errorDetails: errorDetails);
            };
            return ScrollConfiguration(behavior: NoColorScrollBehavior(), child: widget!);
            // return widget!;
            // return ScrollConfiguration(behavior: ScrollBehaviorModified(), child: widget!);
          },
        );
      },
    );
  }
}

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//
//   print("Handling a background message: ${message}");
// }

class NoColorScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
