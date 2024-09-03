import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _clearAllNotifications() async {
    if (_currentUser != null) {
      final recommendations = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('recommendations')
          .get();

      for (var doc in recommendations.docs) {
        await doc.reference.delete();
      }
    }
    setState(() {}); // Rebuild the screen to reflect cleared notifications
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('MMM dd, yyyy • hh:mm a'); // Custom date format
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: _clearAllNotifications,
          ),
        ],
      ),
      body: _currentUser == null
          ? Center(child: Text('No notifications available.'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_currentUser!.uid)
                  .collection('recommendations')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No notifications available.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final bool isRead = data['read'] ?? false;

                    return Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.thumb_up, // Always show thumbs-up icon
                            color: isRead ? Colors.green : null,
                          ),
                          title: Text(data['recommendations'].join('\n'), style: TextStyle(fontSize: 18),),
                          subtitle: Text(
                            _formatTimestamp(data['timestamp'] as Timestamp), // Format the timestamp
                          ),
                          onTap: () {
                            // Mark as read and navigate to activity screen
                            doc.reference.update({'read': true});
                            Navigator.pushNamed(context, '/activities');
                          },
                        ),
                        Divider(), // Horizontal line separator
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}
