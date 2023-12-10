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
      subtitle: Row(children: [
        Container(
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(10), // Adjust the value as needed
            child: Container(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  club.theme,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Container(
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(10), // Adjust the value as needed
            child: Container(
              color: Colors.purple,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  club.genre,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ]),
      leading: Column(
        children: [
          FaIcon(FontAwesomeIcons.peopleGroup),
          SizedBox(height: 6),
          Text(club.members.length.toString()),
        ],
      ),
    ));
  }
}
