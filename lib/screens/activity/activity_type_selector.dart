import 'package:fitness/common/color_extension.dart';
import 'package:flutter/material.dart';

class ActivityTypeSelector extends StatelessWidget {
  final String currentActivity;
  final Function(String) onSelectActivity;

  ActivityTypeSelector({required this.currentActivity, required this.onSelectActivity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showActivitySelectorDialog(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: TextColor.primaryColor1.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          currentActivity,
          style: TextStyle(color: const Color.fromARGB(255, 38, 9, 9), fontSize: 20,),
        ),
      ),
    );
  }

  void _showActivitySelectorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Activity'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: ['Walking', 'Running', 'Cycling', 'Swimming']
                  .map((activity) => ListTile(
                        title: Text(activity),
                        onTap: () {
                          onSelectActivity(activity);
                          Navigator.of(context).pop();
                        },
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
