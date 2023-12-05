import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookbuddy/models/club_model.dart';

class ClubWidget extends StatelessWidget {
  final Club club;

  ClubWidget({required this.club});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(club.name),
        subtitle: Text(club.theme),
      ),
    );
  }
}
