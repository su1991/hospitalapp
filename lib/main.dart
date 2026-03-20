import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gfhfg/Views/signupview.dart';
import 'package:gfhfg/signupview.dart';
import 'package:gfhfg/Views/patientmainscreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Views/loginview.dart';
import 'Views/navaigaitonbar.dart';
import 'Views/navigationdoctor.dart';
import 'package:gfhfg/ViewModel/notifications_service.dart';

Future<void> main() async
{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget
{
  const MyApp({super.key});
  @override
    State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp>
{
  bool isDark = false;

  void toggleTheme()
  {
    setState(()
    {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
      (
      debugShowCheckedModeBanner: false,
        theme: ThemeData
          (
          colorScheme: ColorScheme.fromSeed
            (
            seedColor: const Color(0xFFA1C5CB),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFA1C5CB),

          appBarTheme: const AppBarTheme
            ( shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all( Radius.circular(30))),

            backgroundColor: Color(0xFF7DA2A8),
          ),navigationBarTheme: const NavigationBarThemeData
          ( shadowColor: Colors.red,
            backgroundColor: const Color(0xFF7DA2A8),
          ),
          useMaterial3: true,
        ),

        darkTheme: ThemeData
          (
          colorScheme: ColorScheme.fromSeed

            (
            seedColor: const Color(0xFFA1C5CB),
            brightness: Brightness.dark,

          ),
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme
            (
            backgroundColor: Colors.black,

            )


          ,navigationBarTheme: const NavigationBarThemeData
          (
          backgroundColor: Colors.black,



        ), textTheme: Typography.whiteMountainView.apply(
          bodyColor: Colors.white,
          displayColor: Colors.black,
        ),
          useMaterial3: true,
        ),

      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: signup
        (
        onToggleTheme: toggleTheme,
      ),
    );
  }


}

