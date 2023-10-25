import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  User? _firebaseUser;

  User? get firebaseUser => _firebaseUser;

  set firebaseUser(User? firebaseUser) {
    _firebaseUser = firebaseUser;
    notifyListeners();
  }

  // Your user attributes, e.g., name, profile picture, etc.
  String? name;
  // ... other attributes

  // Fetch user data from Firestore based on the given UID
  void fetchUserData(String uid) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    // Set your user attributes here
    name = userDoc.data()?['name'] ?? '';
    // ... set other attributes

    // Notify listeners of the changes
    notifyListeners();
  }
}
