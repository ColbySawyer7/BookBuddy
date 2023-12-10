import 'package:bookbuddy/components/book.dart';
import 'package:bookbuddy/components/book_footer.dart';
import 'package:bookbuddy/models/book_model.dart';
import 'package:bookbuddy/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void _showAddBookDialog(BuildContext context) {
    final userModel = context.read<UserModel>();
    final bookModel = context.read<BookModel>();
    String isbn = ''; // Variable to store the entered ISBN
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a Book'),
          content: TextField(
            onChanged: (value) {
              isbn = value; // Update ISBN as the user types
            },
            decoration: InputDecoration(hintText: "Enter ISBN"),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.barcode),
              onPressed: () {
                // Call function to add book to Firebase
                userModel.updateLibrary(isbn);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final bookModel = Provider.of<BookModel>(context);
    final library = bookModel.currentlyReading + bookModel.readBooks;

    final List<Book> recs = userModel.highlightedPicks;

    return Consumer<UserModel>(builder: (context, userModel, child) {
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            /* Search Bar
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
            */
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
                          child: BookWidget(
                            imageURL: recs[index].coverImage,
                            isRead: false,
                            canBeRead: false,
                            isbn: recs[index].isbn,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Library",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.plus),
                    onPressed: () {
                      _showAddBookDialog(context);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
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
                              BookWidget(
                                imageURL: library[index].coverImage,
                                isRead: library[index].isRead,
                                isbn: library[index].isbn,
                                canBeRemoved: true,
                              ),
                              SizedBox(height: 6),
                              Expanded(
                                child: BookFooter(
                                  title: library[index].title,
                                  author: library[index].author,
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
      );
    });
  }
}
