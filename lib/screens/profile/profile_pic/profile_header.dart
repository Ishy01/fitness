import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/services/database.dart';
import 'package:fitness/models/user_model.dart';

class ProfileHeader extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String? profilePictureUrl;

  const ProfileHeader({
    Key? key,
    required this.firstName,
    required this.lastName,
    this.profilePictureUrl,
  }) : super(key: key);

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _profilePicture;
  String? _profilePictureUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isUploading = false; // New state for tracking upload status

  @override
  void initState() {
    super.initState();
    _profilePictureUrl = widget.profilePictureUrl;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Close the dialog box before starting the upload
      Navigator.of(context).pop();

      setState(() {
        _profilePicture = File(pickedFile.path);
        _isUploading = true; // Start showing the loading indicator
      });

      await _updateProfilePicture();

      setState(() {
        _isUploading = false; // Stop showing the loading indicator
      });
    } else {
      // Close the dialog box if no image was selected
      Navigator.of(context).pop();
    }
  }

  Future<void> _removeProfilePicture() async {
    setState(() {
      _profilePicture = null;
      _profilePictureUrl = null;
    });

    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseService dbService = DatabaseService(userId: user.uid);
      UserModel updatedUser = UserModel(
        uid: user.uid,
        firstName: widget.firstName,
        lastName: widget.lastName,
        email: user.email!,
        profilePictureUrl: null,
      );

      await dbService.updateUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile picture removed')));
    }
  }

  Future<void> _updateProfilePicture() async {
    if (_profilePicture != null) {
      User? user = _auth.currentUser;
      if (user != null) {
        String? profilePictureUrl = await _uploadProfilePicture(user.uid);
        setState(() {
          _profilePictureUrl = profilePictureUrl;
        });

        DatabaseService dbService = DatabaseService(userId: user.uid);
        UserModel updatedUser = UserModel(
          uid: user.uid,
          firstName: widget.firstName,
          lastName: widget.lastName,
          email: user.email!,
          profilePictureUrl: profilePictureUrl,
        );

        await dbService.updateUser(updatedUser);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile picture updated')));
      }
    }
  }

  Future<String?> _uploadProfilePicture(String userId) async {
    final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/$userId.jpg');
    final uploadTask = storageRef.putFile(_profilePicture!);
    final snapshot = await uploadTask.whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: _profilePicture != null
                  ? FileImage(_profilePicture!)
                  : _profilePictureUrl != null
                      ? NetworkImage(_profilePictureUrl!)
                      : AssetImage('assets/default_profile_picture.png') as ImageProvider,
              child: _profilePictureUrl == null ? Icon(Icons.person, size: 60) : null,
            ),
            if (_isUploading) // Display the loading indicator when uploading
              Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.grey),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Profile Picture'),
                          content: Text('Do you want to change or remove your profile picture?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Remove'),
                              onPressed: () {
                                _removeProfilePicture();
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Change'),
                              onPressed: _pickImage,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10), // Add spacing between the image and the name
        Text(
          widget.firstName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.lastName,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
