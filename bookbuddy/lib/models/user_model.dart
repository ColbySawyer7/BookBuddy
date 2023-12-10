import 'dart:async';
import 'package:bookbuddy/models/club_model.dart';
import 'package:bookbuddy/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:bookbuddy/components/club.dart';

class UserModel extends ChangeNotifier {
  User? _firebaseUser;

  User? get firebaseUser => _firebaseUser;

  set firebaseUser(User? firebaseUser) {
    _firebaseUser = firebaseUser;
    notifyListeners();
  }

  // Your user attributes, e.g., name, profile picture, etc.
  String? name;
  String? email;
  String? bio;
  List<String>? library;
  List<String>? clubIDs = [];
  List<Club> clubs = [];
  List<Book> highlightedPicks = [];

  final _dataCompleter = Completer<void>();
  Future<void> get dataReady => _dataCompleter.future;

  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }

  void updateBio(String newBio) {
    bio = newBio;
    notifyListeners();
  }

  void updateLibrary(String isbn) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseUser?.uid)
        .update({
      'lib': FieldValue.arrayUnion([isbn]),
    });
    notifyListeners();
  }

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
    email = userDoc.data()?['email'] ?? '';
    bio = userDoc.data()?['bio'] ?? '';

    // Fetch the user's library
    fetchLibrary(context);

    // Fetch the list of Club IDs associated with the user
    fetchClubs(context);

    // Update user latest login information
    updateUserData();
    // Notify listeners of the changes
    notifyListeners();

    // Once everything is set:
    if (!_dataCompleter.isCompleted) {
      _dataCompleter.complete();
    }
  }

  Future<void> fetchClubs(BuildContext context) async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseUser?.uid)
          .get();

      clubIDs = List<String>.from(userDoc.data()?['joinedClubs'] ?? []);
      print("Fetched club IDs: $clubIDs");

      clubIDs!.forEach((clubID) async {
        print("Fetching club with ID: $clubID");

        // Check if the club with the same ID already exists in the 'clubs' list
        bool clubExists = clubs.any((club) => club.id == clubID);

        if (!clubExists) {
          final club = await Club.fetchClub(clubID);
          if (club != null) {
            print("Fetched club: ${club.name}");
            clubs.add(club);
          }
        } else {
          print("Club with ID $clubID already exists in the 'clubs' list.");
        }
      });

      notifyListeners();
    } catch (error) {
      print("Error fetching club IDs: $error");
    }
  }

  Future<void> fetchHighlightedPicks(BuildContext context) async {
    final picks = [
      "https://covers.openlibrary.org/b/olid/OL28944960M-L.jpg",
      "https://m.media-amazon.com/images/I/91aCox8y3rL._SL1500_.jpg",
      "https://m.media-amazon.com/images/I/51IrW578SQL._SY300_.jpg",
      "https://m.media-amazon.com/images/I/51KHidbIlRL._SY300_.jpg",
      "https://m.media-amazon.com/images/I/51Ck0yr+jrL._SY300_.jpg",
      "https://m.media-amazon.com/images/I/51iCNetZNeL._SY300_.jpg",
      "https://m.media-amazon.com/images/I/519TilmNL+L._SY300_.jpg",
      "https://m.media-amazon.com/images/I/51JwQT+XVCL._SY300_.jpg",
    ];

    picks.forEach((element) {
      highlightedPicks.add(Book(
        coverImage: element,
        title: "",
        isbn: "",
        author: '',
      ));
    });
  }
}
