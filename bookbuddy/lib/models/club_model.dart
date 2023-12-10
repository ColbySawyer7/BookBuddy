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

  static Future<Club?> fetchClub(String clubID) async {
    // Fetch club by ID from Firestore
    try {
      var clubDoc = await FirebaseFirestore.instance
          .collection('clubs')
          .doc(clubID)
          .get();

      if (clubDoc.exists) {
        // Club document exists, you can access its data
        final name = clubDoc.data()?['name'] ?? '';
        print("Fetched club name: $name");
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
      } else {
        // Club document doesn't exist
        print('Club document not found for ID: $clubID');
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      print('Error fetching club document: $e');
    }
  }

  static Future<void> addClub(Club club) async {
    // Add club to Firestore
    try {
      await FirebaseFirestore.instance
          .collection('clubs')
          .doc()
          .set({'name': 'My Club'});
    } catch (e) {
      // Handle any errors that occur during the add
      print('Error adding club document: $e');
    }
  }
}
