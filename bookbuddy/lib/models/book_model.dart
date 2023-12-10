import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Book {
  final String isbn;
  final String coverImage;
  final String author;
  final String title;
  final bool isRead;

  Book({
    required this.isbn,
    required this.coverImage,
    required this.author,
    required this.title,
    required this.isRead,
  });
}

class BookModel with ChangeNotifier {
  User? _firebaseUser;

  User? get firebaseUser => _firebaseUser;
  List<Book> _currentlyReading = [];
  List<Book> _readBooks = [];
  List<Book> _recommendations = [];
  List<Book> _clubBooks = [];

  List<Book> get currentlyReading => _currentlyReading;
  List<Book> get recommendations => _recommendations;
  List<Book> get clubBooks => _clubBooks;
  List<Book> get readBooks => _readBooks;

  void addBook(Book book) {
    _currentlyReading.add(book);
    notifyListeners();
  }

  void setLibraryBooks(List<Book> booksList) {
    _currentlyReading = booksList;
    notifyListeners();
  }

  void setReadBooks(List<Book> booksList) {
    _readBooks = booksList;
    notifyListeners();
  }
}
