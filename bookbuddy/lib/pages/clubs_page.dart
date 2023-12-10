import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bookbuddy/models/user_model.dart';
import 'package:bookbuddy/components/club.dart';
import 'package:bookbuddy/models/club_model.dart';

class ClubsPage extends StatelessWidget {
  void _showAddClubDialog(BuildContext context) {
    final userModel = context.read<UserModel>();
    String name = '';
    String theme = '';
    String genre = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          constraints:
              BoxConstraints(maxHeight: 200), // Set the maximum height here
          child: AlertDialog(
            title: Text('Add a Book'),
            content: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    name = value; // Update ISBN as the user types
                  },
                  decoration: InputDecoration(hintText: "Enter Name"),
                ),
                TextField(
                  onChanged: (value) {
                    theme = value; // Update ISBN as the user types
                  },
                  decoration: InputDecoration(hintText: "Enter Theme"),
                ),
                TextField(
                  onChanged: (value) {
                    genre = value; // Update ISBN as the user types
                  },
                  decoration: InputDecoration(hintText: "Enter Genre"),
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.save),
                onPressed: () {
                  // Call function to add book to Firebase
                  userModel.addClub(name, genre, theme);
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Your Clubs'),
          forceMaterialTransparency: true,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.black,
          actions: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.plus),
              onPressed: () {
                _showAddClubDialog(context);
              },
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userModel.clubs.isNotEmpty
            ? ListView.builder(
                itemCount: userModel.clubs.length,
                itemBuilder: (context, index) {
                  return ClubWidget(
                    club: userModel.clubs[index],
                  );
                },
              )
            : Center(
                child: Text(
                  'You are not in any clubs yet.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
      ),
    );
  }
}
