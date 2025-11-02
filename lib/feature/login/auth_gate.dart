import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_wealth_tracker/feature/dashboard/dashboard_view.dart';
import 'package:personal_wealth_tracker/feature/login/login_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Listens to the authentication state stream.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show a loading spinner while checking the state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If the user is logged in (snapshot.hasData is true)
        if (snapshot.hasData && snapshot.data != null) {
          // Navigate to the main application screen (placeholder)
          return Dashboard();
        }

        // If the user is NOT logged in
        return const LoginScreen();
      },
    );
  }
}
