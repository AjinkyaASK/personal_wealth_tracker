import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends ChangeNotifier {
  AuthController._();

  static AuthController get instance => _instance;
  static final AuthController _instance = AuthController._();

  // --- Core Google Sign-In Function ---
  Future<UserCredential> _signInWithGoogle() async {
    await GoogleSignIn.instance.initialize();
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Placeholder function for Google Sign-In interaction
  Future<void> handleGoogleSignIn(BuildContext context) async {
    // IMPORTANT: Integrate real Google Sign-In logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google Sign-In initiated...'),
        duration: Duration(seconds: 1),
      ),
    );

    final UserCredential credentials = await _signInWithGoogle();
    print('Signed in as ${credentials.user?.displayName}');
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
