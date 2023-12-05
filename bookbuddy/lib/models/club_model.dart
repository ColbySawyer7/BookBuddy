import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Club {
  final String id;
  final String name;
  final String genre;
  final List<String> members;
  final List<String> books;
  final String theme;

  Club({
    required this.id,
    required this.name,
    required this.genre,
    required this.members,
    required this.books,
    required this.theme,
  });

  static Future<Club> fetchClub(String clubID) async {
    // Fetch club by ID from Firestore
    var clubDoc =
        await FirebaseFirestore.instance.collection('clubs').doc(clubID).get();

    final name = clubDoc.data()?['name'] ?? '';
    final theme = clubDoc.data()?['theme'] ?? '';
    final genre = clubDoc.data()?['genre'] ?? '';
    final members = List<String>.from(clubDoc.data()?['members'] ?? []);
    final books = List<String>.from(clubDoc.data()?['books'] ?? []);

    return Club(
      id: clubID,
      name: name,
      theme: theme,
      genre: genre,
      members: members,
      books: books,
    );
  }
}
