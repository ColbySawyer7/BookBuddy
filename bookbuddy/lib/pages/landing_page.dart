import 'package:bookbuddy/components/book.dart';
import 'package:bookbuddy/components/book_footer.dart';
import 'package:bookbuddy/models/book_model.dart';
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
  @override
  Widget build(BuildContext context) {
    final bookModel = Provider.of<BookModel>(context);
    final library = bookModel.currentlyReading;

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

    return SafeArea(
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
                          child: BookWidget(
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
                              BookWidget(
                                imageURL: library[index].coverImage,
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
      ),
    );
  }
}
