import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var users = snapshot.data!.docs;
          List<Widget> userWidgets = [];
          for (var user in users) {
            userWidgets.add(ListTile(
              title: Text(user['name']),
              subtitle: Text(user['email']),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(user.id)));
              },
            ));
          }
          return ListView(
            children: userWidgets,
          );
        },
      ),
    );
  }
}
