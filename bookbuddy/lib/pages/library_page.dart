import 'package:bookbuddy/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
          child: Column(
        children: [Text("Your Library")],
      )),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
