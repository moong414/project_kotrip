import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/core/theme/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_kotrip/core/widgets/app_bt_navi.dart';
import 'package:project_kotrip/pages/splash/splash_page.dart';
import 'package:project_kotrip/pages/splash/view_model/auth_view_model.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authViewModelProvider.notifier).authState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

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
      home: authState.isSignedIn 
      ?AppBtNavi()
      :SplashPage(),
    );
  }
}
