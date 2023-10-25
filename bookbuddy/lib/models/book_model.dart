import 'package:flutter/material.dart';

class Book {
  final String isbn;
  final String coverImage;
  final String author;
  final String title;

  Book(
      {required this.isbn,
      required this.coverImage,
      required this.author,
      required this.title});
}

class BookModel with ChangeNotifier {
  List<Book> _currentlyReading = [];
  List<Book> _recommendations = [];
  List<Book> _clubBooks = [];

  List<Book> get currentlyReading => _currentlyReading;
  List<Book> get recommendations => _recommendations;
  List<Book> get clubBooks => _clubBooks;

  void addBook(Book book) {
    _currentlyReading.add(book);
    notifyListeners();
  }

  void setBooks(List<Book> booksList) {
    _currentlyReading = booksList;
    notifyListeners();
  }
}
