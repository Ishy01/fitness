import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/common_widgets/rounded_button.dart';
import 'package:fitness/models/user_model.dart';
import 'package:fitness/services/database.dart';
import 'package:flutter/material.dart';

class PersonalDataScreen extends StatefulWidget {
  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  String? firstName;
  String? lastName;
  String? height;
  String? weight;
  String? dateOfBirth;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseService dbService = DatabaseService(userId: user.uid);
      var userData = await dbService.getUser(user.uid);
      if (userData != null) {
        setState(() {
          firstName = userData.firstName;
          lastName = userData.lastName;
          height = userData.height?.toString();
          weight = userData.weight?.toString();
          dateOfBirth = userData.dateOfBirth;
        });

        _firstNameController.text = firstName ?? '';
        _lastNameController.text = lastName ?? '';
        _heightController.text = height ?? '';
        _weightController.text = weight ?? '';
        _dateOfBirthController.text = dateOfBirth ?? '';
      }
    }
  }

  Future<void> _updateUserData() async {
  if (_formKey.currentState!.validate()) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseService dbService = DatabaseService(userId: user.uid);

      var updatedUser = UserModel(
        uid: user.uid,
        email: user.email,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        height: _heightController.text.trim(),
        weight: _weightController.text.trim(),
        dateOfBirth: _dateOfBirthController.text.trim(),
      );

      await dbService.updateUser(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Personal data updated successfully!')),
      );

      // Refresh the displayed data
      _fetchUserData();
      // Pass the updated data back to ProfileScreen
      Navigator.pop(context, updatedUser);
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (m)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateOfBirthController,
                decoration: InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              RoundedButton(
                title: "Save Changes",
                onPressed: _updateUserData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
