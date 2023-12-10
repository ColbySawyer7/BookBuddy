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
  List<String>? readBooks;
  List<String>? clubIDs = [];
  List<Club> clubs = [];
  List<Book> highlightedPicks = [];

  final _dataCompleter = Completer<void>();
  Future<void> get dataReady => _dataCompleter.future;

  void updateUI() {
    if (!_dataCompleter.isCompleted) {
      _dataCompleter.complete();
    }
    notifyListeners();
  }

  void updateName(String newName) {
    name = newName;
    updateUI();
  }

  void updateEmail(String newEmail) {
    email = newEmail;
    updateUI();
  }

  void updateBio(String newBio) {
    bio = newBio;
    updateUI();
  }

  void updateLibrary(String isbn) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseUser?.uid)
        .update({
      'lib': FieldValue.arrayUnion([isbn]),
    });
    updateUI();
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
      List<String> lib = List<String>.from(userDoc.data()?['lib'] ?? []);
      List<String> readBooks =
          List<String>.from(userDoc.data()?['readBooks'] ?? []);

      // A list to store fetched books
      List<Book> fetchedLibraryBooks = [];
      List<Book> fetchedReadBooks = [];

      // For each ISBN, fetch the book data (Library)
      for (String isbn in lib) {
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
          fetchedLibraryBooks.add(Book(
              isbn: isbn,
              author: author,
              title: title,
              coverImage: 'https://covers.openlibrary.org/b/isbn/$isbn-L.jpg',
              isRead: false));
        } else {
          print("Failed to fetch book with ISBN: $isbn");
        }
      }

      // For each ISBN, fetch the book data (Read Books)
      for (String isbn in readBooks) {
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
          fetchedReadBooks.add(Book(
              isbn: isbn,
              author: author,
              title: title,
              coverImage: 'https://covers.openlibrary.org/b/isbn/$isbn-L.jpg',
              isRead: true));
        } else {
          print("Failed to fetch book with ISBN: $isbn");
        }
      }
      // Update the BookModel with the fetched books
      bookModel.setLibraryBooks(fetchedLibraryBooks);
      bookModel.setReadBooks(fetchedReadBooks);
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

    fetchHighlightedPicks(context);

    // Update user latest login information
    updateUserData();
    updateUI();
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
    } catch (error) {
      print("Error fetching club IDs: $error");
    }
  }

  Future<void> fetchHighlightedPicks(BuildContext context) async {
    final picks = [
      "9781847941831",
      "9781668016138",
      "9780385534260",
    ];

    // For each ISBN, fetch the book data (Library)
    for (String isbn in picks) {
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
        bool bookExists = highlightedPicks.any((book) => book.isbn == isbn);
        bool bookNotInLibrary = !(readBooks?.contains(isbn) ?? false) &&
            !(library?.contains(isbn) ?? false);

        if (!bookExists && bookNotInLibrary) {
          highlightedPicks.add(Book(
              isbn: isbn,
              author: author,
              title: title,
              coverImage: 'https://covers.openlibrary.org/b/isbn/$isbn-L.jpg',
              isRead: false));
        }
      } else {
        print("Failed to fetch book with ISBN: $isbn");
      }
    }
  }

  void markRead(String isbn) async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseUser?.uid)
        .get();

    var lib = List<String>.from(userDoc.data()?['lib'] ?? []);
    var readBooks = List<String>.from(userDoc.data()?['readBooks'] ?? []);

    if (lib.contains(isbn)) {
      lib.remove(isbn);
      readBooks.add(isbn);
    } else if (readBooks.contains(isbn)) {
      readBooks.remove(isbn);
      lib.add(isbn);
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseUser?.uid)
        .update({
      'lib': lib,
      'readBooks': readBooks,
    });
    library = lib;
    readBooks = readBooks;
    updateUI();
  }

  void addToLibrary(String isbn) async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseUser?.uid)
        .get();

    var lib = List<String>.from(userDoc.data()?['lib'] ?? []);

    if (!lib.contains(isbn)) {
      lib.insert(0, isbn);
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseUser?.uid)
        .update({
      'lib': lib,
    });
    library = lib;
    updateUI();
  }

  void removeFromLibrary(String isbn) async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseUser?.uid)
        .get();

    var lib = List<String>.from(userDoc.data()?['lib'] ?? []);

    if (lib.contains(isbn)) {
      lib.remove(isbn);
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseUser?.uid)
        .update({
      'lib': lib,
    });
    library = lib;
    updateUI();
  }

  void addClub(Club club) async {
    clubs.add(club);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseUser?.uid)
        .update({
      'joinedClubs': FieldValue.arrayUnion([club.id]),
    });

    updateUI();
  }
}
