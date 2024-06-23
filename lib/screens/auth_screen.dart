import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'users_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  late String name, email, mobile, password;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Chat App'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade500,
      ),
      body: ListView(
        children:[ Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                width: size.height / 2,
                alignment: Alignment.center,
                child: Text(
                  "Welcome user ",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(hintText: 'Name',border: OutlineInputBorder(borderRadius:BorderRadius.circular(20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    mobile = value;
                  },
                  decoration: InputDecoration(hintText: 'Mobile Number',border: OutlineInputBorder(borderRadius:BorderRadius.circular(20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(hintText: 'Email',border: OutlineInputBorder(borderRadius:BorderRadius.circular(20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(hintText: 'Password',border: OutlineInputBorder(borderRadius:BorderRadius.circular(20))),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        Size(200, 50)), // Set width and height
                    backgroundColor: MaterialStateProperty.all(Colors.blue.shade100),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
                onPressed: () async {
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(newUser.user!.uid)
                          .set({
                        'name': name,
                        'mobile': mobile,
                        'email': email,
                      });
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => UsersScreen()));
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text('Sign Up',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          Size(200, 50)), // Set width and height
                      backgroundColor: MaterialStateProperty.all(Colors.blue.shade100),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                  onPressed: () async {
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => UsersScreen()));
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text('Sign In',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        ),
      ],)
    );
  }
}
