import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_kotrip/pages/splash/splash_page.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ko'),
      supportedLocales: const [
        Locale('en'), // 영어
        Locale('ko'), // 한국어
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: colPrimary,
          surface: Colors.white,
        ),
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
        fontFamily: 'SCDream',
      ),
      home: SplashPage(),
    );
  }
}
