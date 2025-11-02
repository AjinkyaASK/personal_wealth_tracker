import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_wealth_tracker/feature/login/auth_gate.dart';
import 'package:personal_wealth_tracker/feature/login/login_view.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wealth Tracker',
      // Apply a modern, clean theme with a specific color scheme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
          primary: Colors.blueGrey,
          secondary: Colors.white,
          primaryContainer: Colors.white,
        ),
        useMaterial3: true,
        // Using a standard, clean font
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
          primary: Colors.blueGrey,
          secondary: Colors.blueGrey.shade900,
          primaryContainer: Color.fromARGB(255, 27, 34, 38),
        ),
        // scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
        // Using a standard, clean font
        fontFamily: 'Roboto',
      ),
      themeMode: ThemeMode.system,
      // home: Dashboard(),
      home: AuthGate(),
    );
  }
}
