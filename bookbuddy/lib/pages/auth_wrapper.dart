import 'package:bookbuddy/models/user_model.dart';
import 'package:bookbuddy/pages/home_page.dart';
import 'package:bookbuddy/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final userModel = context.read<UserModel>();

        if (snapshot.hasData && snapshot.data != null) {
          // Set the Firebase user in the UserModel
          userModel.firebaseUser = snapshot.data;
          context.read<UserModel>().fetchUserData(context);

          // Return the main app's home page
          return HomePage();
        } else {
          // Clear the Firebase user in the UserModel
          userModel.firebaseUser = null;

          // If the user is not logged in, return the login/register screen
          return LoginPage();
        }
      },
    );
  }
}
