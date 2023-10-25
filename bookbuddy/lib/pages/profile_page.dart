import 'package:bookbuddy/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
