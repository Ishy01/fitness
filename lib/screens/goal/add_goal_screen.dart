import 'package:fitness/common_widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:fitness/models/goal_model.dart';
import 'package:intl/intl.dart';

class AddGoalScreen extends StatefulWidget {
  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  String _goalType = 'Steps';
  String _target = '';
  bool _isDaily = true;

  void _saveGoal() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String dateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
      GoalModel newGoal = GoalModel(
        title: _goalType,
        target: _target,
        current: "0",
        progress: 0.0,
        date: dateString,
      );
      Navigator.pop(context, newGoal);
    }
  }

  String getTargetUnit() {
    switch (_goalType) {
      case 'Steps':
        return 'steps';
      case 'Calories':
        return 'kcal';
      case 'Distance':
        return 'km';
      case 'Workout':
        return 'sessions';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _goalType,
                items: ['Steps', 'Calories', 'Distance', 'Workout']
                    .map((String category) {
                  return DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: <Widget>[
                          Text(category),
                        ],
                      ));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _goalType = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Goal Type'),
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Target (${getTargetUnit()})'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a target value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _target = value!;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              RoundedButton(
                title: "Save Goal",
                onPressed: _saveGoal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
