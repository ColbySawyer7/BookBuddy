import 'dart:async';

import 'package:bookbuddy/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserModel extends ChangeNotifier {
  User? _firebaseUser;

  User? get firebaseUser => _firebaseUser;

  set firebaseUser(User? firebaseUser) {
    _firebaseUser = firebaseUser;
    notifyListeners();
  }

  // Your user attributes, e.g., name, profile picture, etc.
  String? name;
  List<String>? library;

  final _dataCompleter = Completer<void>();
  Future<void> get dataReady => _dataCompleter.future;

  void updateUserData() async {
    // Update the lastLogin field with the current datetime
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseUser?.uid)
        .update({
      'lastLogin': DateTime.now(),
    });
  }

  void fetchLibrary(BuildContext context) async {
    final bookModel = Provider.of<BookModel>(context, listen: false);
    try {
      // Fetch the user's data
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseUser?.uid)
          .get();
      List<String> isbns = List<String>.from(userDoc.data()?['lib'] ?? []);

      // A list to store fetched books
      List<Book> fetchedBooks = [];

      // For each ISBN, fetch the book data
      for (String isbn in isbns) {
        final response = await http.get(
          Uri.parse(
              'https://openlibrary.org/api/books?bibkeys=ISBN:$isbn&format=json&jscmd=data'),
        );
        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          var bookData = jsonData['ISBN:$isbn'];

          String title = bookData['title'] ?? '';
          String author = bookData['authors'] != null
              ? bookData['authors'][0]['name']
              : ''; // Assuming the first author in the list
          fetchedBooks.add(Book(
              isbn: isbn,
              author: author,
              title: title,
              coverImage: 'https://covers.openlibrary.org/b/isbn/$isbn-L.jpg'));
        } else {
          print("Failed to fetch book with ISBN: $isbn");
        }
      }
      // Update the BookModel with the fetched books
      bookModel.setBooks(fetchedBooks);
    } catch (error) {
      print("Error fetching library: $error");
    }
  }

  // Fetch user data from Firestore based on the given UID
  void fetchUserData(BuildContext context) async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseUser?.uid)
        .get();

    // Set your user attributes here
    name = userDoc.data()?['name'] ?? '';

    // Fetch the user's library
    fetchLibrary(context);

    // Update user latest login information
    updateUserData();
    // Notify listeners of the changes
    notifyListeners();

    // Once everything is set:
    if (!_dataCompleter.isCompleted) {
      _dataCompleter.complete();
    }
  }
}
