import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bookbuddy/models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userModel = context.read<UserModel>();
    userModel.fetchUserData(context); // Fetch user data here
    _nameController.text = userModel.name ?? '';
    _emailController.text = userModel.email ?? '';
    _bioController.text = userModel.bio ?? '';
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    final userModel = context.read<UserModel>();

    userModel.updateName(_nameController.text);
    userModel.updateEmail(_emailController.text);
    userModel.updateBio(_bioController.text);

    _toggleEditing();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profile",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: _isEditing
                        ? Icon(FontAwesomeIcons.save)
                        : Icon(FontAwesomeIcons.edit),
                    onPressed: () {
                      if (_isEditing) {
                        _saveChanges();
                      } else {
                        _toggleEditing();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  userModel.firebaseUser?.photoURL ??
                      'https://firebasestorage.googleapis.com/v0/b/bookbuddy-f165a.appspot.com/o/cls.jpg?alt=media&token=d2a65011-c4cc-4eea-99bd-8ee214181f66',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                enabled: _isEditing,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                enabled: _isEditing,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _bioController,
                enabled: _isEditing,
                maxLines: null,
                decoration: InputDecoration(labelText: 'Bio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
