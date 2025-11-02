import 'package:flutter/material.dart';
import 'package:personal_wealth_tracker/feature/login/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 1. App Logo (Icon matching the mockup)
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    // Using a wallet/card icon to represent the app logo
                    Icons.account_balance_wallet_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),

              // 2. Welcome Text
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Sign in to manage your wealth portfolio.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 64.0),

              // 3. Login with Google Button (Exact match for the mockup)
              _buildGoogleSignInButton(
                context,
                Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 24.0),

              // 4. Terms and Privacy links
              _buildTermsAndPrivacyText(context),
            ],
          ),
        ),
      ),
    );
  }

  // Custom method to build the Google Sign-In Button
  Widget _buildGoogleSignInButton(BuildContext context, Color primaryPurple) {
    return MaterialButton(
      onPressed: () => AuthController.instance.handleGoogleSignIn(context),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      color: Theme.of(context).colorScheme.secondary,
      shape: StadiumBorder(),
      elevation: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Google 'G' icon placeholder
          Image.asset(
            'assets/icon/google-logo.png',
            height: 24,
            width: 24,
            errorBuilder: (context, error, stackTrace) {
              return Text(
                'G',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              );
            },
          ),
          const SizedBox(width: 12.0),
          const Text(
            'Sign In with Google',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // Custom method for terms and privacy text
  Widget _buildTermsAndPrivacyText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'By signing in, you agree to whatever we say, whenever we want.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
    );
  }
}
