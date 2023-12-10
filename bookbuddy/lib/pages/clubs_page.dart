import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bookbuddy/models/user_model.dart';
import 'package:bookbuddy/components/club.dart';
import 'package:bookbuddy/models/club_model.dart';

class ClubsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Clubs'),
        forceMaterialTransparency: true,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        /*actions: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.plus),
              onPressed: () {},
            ),
          ]*/
      ),
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
