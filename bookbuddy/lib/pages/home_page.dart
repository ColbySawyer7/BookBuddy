import 'package:bookbuddy/components/book.dart';
import 'package:bookbuddy/components/book_footer.dart';
import 'package:bookbuddy/models/book_model.dart';
import 'package:bookbuddy/models/user_model.dart';
import 'package:bookbuddy/pages/clubs_page.dart';
import 'package:bookbuddy/pages/landing_page.dart';
import 'package:bookbuddy/pages/library_page.dart';
import 'package:bookbuddy/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // By default, the first tab is selected
  final List<Widget> _pages = [
    LandingPage(),
    ClubsPage(),
    LibraryPage(),
    ProfilePage()
  ];

  // Provider Models
  late UserModel userModel;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    userModel = context.read<UserModel>();
  }

  @override
  Widget build(BuildContext context) {
    // Data extracted from models
    final username = userModel.name ?? 'Default Name';

    return FutureBuilder<void>(
      future: userModel.dataReady,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final username = userModel.name ?? 'Default Name';
          return Scaffold(
            appBar: AppBar(
              title: Text('Welcome, ' + username),
              actions: <Widget>[
                // The sign-out button
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await signOut();

                    // Optionally, navigate to another page after signing out
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ],
            ),
            body: Stack(
              children: _pages
                  .asMap()
                  .map((index, page) {
                    // For each page, create a visibility controlled widget
                    return MapEntry(
                        index,
                        Offstage(
                          offstage: _selectedIndex != index,
                          child: TickerMode(
                            enabled: _selectedIndex == index,
                            child: page,
                          ),
                        ));
                  })
                  .values
                  .toList(),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
              ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: 8,
                  activeColor: Colors.blue,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.grey[100]!,
                  color: Colors.black,
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                    //Navigator.pushNamed(context, routes[index]);
                  },
                  tabs: [
                    GButton(
                      icon: FontAwesomeIcons.house,
                      text: 'Home',
                    ),
                    GButton(
                      icon: FontAwesomeIcons.userGroup,
                      text: 'Clubs',
                    ),
                    GButton(
                      icon: FontAwesomeIcons.bookOpen,
                      text: 'Library',
                    ),
                    GButton(
                      icon: FontAwesomeIcons.person,
                      text: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          // While data is still loading:
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
