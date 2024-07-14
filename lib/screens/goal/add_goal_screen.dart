import 'package:flutter/material.dart';

class AddGoalScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _goalTitle = '';
  String _target = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Goal Title'),
                onSaved: (value) {
                  _goalTitle = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal title';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Target'),
                onSaved: (value) {
                  _target = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a target';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Handle goal addition logic
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
