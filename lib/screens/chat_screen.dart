import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithUserId;
  ChatScreen(this.chatWithUserId);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
 late User loggedInUser;
 late String message;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('messages').doc(loggedInUser.uid).collection(widget.chatWithUserId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  var messageText = message['text'];
                  var messageSender = message['sender'];
                  var messageWidget = ListTile(
                    title: Text('$messageText from $messageSender'),
                  );
                  messageWidgets.add(messageWidget);
                }
                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),
          TextField(
            onChanged: (value) {
              message = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter your message...',
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _firestore.collection('messages').doc(loggedInUser.uid).collection(widget.chatWithUserId).add({
                    'text': message,
                    'sender': loggedInUser.email,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  _firestore.collection('messages').doc(widget.chatWithUserId).collection(loggedInUser.uid).add({
                    'text': message,
                    'sender': loggedInUser.email,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  message = '';
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
