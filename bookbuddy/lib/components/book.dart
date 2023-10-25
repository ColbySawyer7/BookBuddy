import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookWidget extends StatelessWidget {
  final String imageURL;

  const BookWidget({super.key, required this.imageURL});

  @override
  Widget build(BuildContext context) {
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
          imageURL.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'lib/assets/noCover.png',
                    image: imageURL,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Icon(
                    FontAwesomeIcons.book,
                    color: Colors.white,
                  ),
                ),
        ],
      ),
    );
  }
}
