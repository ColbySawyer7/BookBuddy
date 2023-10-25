import 'package:bookbuddy/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class ClubsPage extends StatefulWidget {
  const ClubsPage({super.key});

  @override
  State<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: const SafeArea(
          child: Column(
        children: [Text("Your Library")],
      )),
      bottomNavigationBar: BottomNavBar(),
    );
    ;
  }
}
