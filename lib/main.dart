import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_wealth_tracker/feature/dashboard/dashboard_view.dart';
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
      title: 'Personal Wealth Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Dashboard(),
    );
  }
}
