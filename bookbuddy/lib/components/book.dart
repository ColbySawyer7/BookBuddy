import 'package:bookbuddy/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BookWidget extends StatefulWidget {
  final String imageURL;
  final String isbn;
  final bool isRead; // Property to track read status
  final bool canBeRead; // Property to track if book can be read
  final bool canBeRemoved; // Property to track if book can be removed

  BookWidget(
      {Key? key,
      required this.imageURL,
      required this.isbn,
      required this.isRead,
      this.canBeRead = true,
      this.canBeRemoved = false})
      : super(key: key);

  @override
  _BookWidgetState createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget> {
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    return Container(
      width: 120,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // If the imageURL is not specified or fails to load, the grey background of the container will be visible.
          Opacity(
            opacity: widget.isRead ? 0.5 : 1.0,
            child: widget.imageURL.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'lib/assets/noCover.png',
                      image: widget.imageURL,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Icon(
                      FontAwesomeIcons.book,
                      color: Colors.white,
                    ),
                  ),
          ),
          widget.canBeRead
              ? Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      // Call function to add book to Firebase
                      print("Updating read status for ISBN: ${widget.isbn}");
                      userModel.markRead(widget.isbn);
                      setState(() {});
                    },
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          widget.isRead
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: widget.isRead ? Colors.green : Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                )
              : Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      // Call function to add book to Firebase
                      print("Adding ISBN to library: ${widget.isbn}");
                      userModel.addToLibrary(widget.isbn);
                      setState(() {});
                    },
                    child: Container(
                      color: Colors.blue,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
          widget.canBeRemoved
              ? Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      // Call function to add book to Firebase
                      print("Removing ISBN from library: ${widget.isbn}");
                      userModel.removeFromLibrary(widget.isbn);
                      setState(() {});
                    },
                    child: Container(
                      color: Colors.red,
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
