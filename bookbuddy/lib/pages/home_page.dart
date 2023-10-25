import 'package:bookbuddy/components/book.dart';
import 'package:bookbuddy/components/book_footer.dart';
import 'package:bookbuddy/components/bottom_nav_bar.dart';
import 'package:bookbuddy/models/user_model.dart';
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
  var recs = [
    "https://covers.openlibrary.org/b/olid/OL28944960M-L.jpg",
    "https://m.media-amazon.com/images/I/91aCox8y3rL._SL1500_.jpg",
    "https://m.media-amazon.com/images/I/51IrW578SQL._SY300_.jpg",
    "https://m.media-amazon.com/images/I/51KHidbIlRL._SY300_.jpg",
    "https://m.media-amazon.com/images/I/51Ck0yr+jrL._SY300_.jpg",
    "https://m.media-amazon.com/images/I/51iCNetZNeL._SY300_.jpg",
    "https://m.media-amazon.com/images/I/519TilmNL+L._SY300_.jpg",
    "https://m.media-amazon.com/images/I/51JwQT+XVCL._SY300_.jpg",
  ];

  var library = [];

  void fetchLibrary() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        library = userData['library'];
      });
    }
    print("Library: " + library.toString());
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    fetchLibrary();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserModel>();
    final username = userModel.name ?? 'Default Name';
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.magnifyingGlass,
                            size: 18, color: Colors.blue),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Search',
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        FaIcon(FontAwesomeIcons.sliders,
                            size: 18, color: Colors.blue)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Recommendations",
                style: GoogleFonts.montserrat(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 20),
              Container(
                height: 200,
                child: recs.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Book(
                              imageURL: recs[index],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "Your library is currently empty",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 20),
              Text(
                "Your Library",
                style: GoogleFonts.montserrat(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 20),
              Container(
                height: 275,
                child: library.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: library.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Book(
                                  imageURL: library[index][2],
                                ),
                                SizedBox(height: 6),
                                Expanded(
                                  child: BookFooter(
                                    title: library[index][0],
                                    author: library[index][1],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "Your library is currently empty",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
