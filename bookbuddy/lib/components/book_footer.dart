import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookFooter extends StatelessWidget {
  final String title;
  final String author;

  const BookFooter({super.key, required this.title, required this.author});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            author,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
