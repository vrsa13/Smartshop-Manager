import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/models/model.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class StoreScreen extends StatefulWidget {
  static String id = 'store_screen';
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final _auth = FirebaseAuth.instance;
  String name;
  String location;
  String contact;
  String email;
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    setFields();
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

  void setFields() {
    _firestore.collection('stores').get().then((res) {
      res.docs.forEach((result) {
        _firestore.collection('stores').doc(result.id).get().then((value) {
          if (value.data()["uid"] == _auth.currentUser.uid) {
            nameController.text = value.data()["name"];
            locationController.text = value.data()["location"];
            contactController.text = value.data()["contact"];
            emailController.text = value.data()["email"];
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Consumer<Song>(builder: (context, song, child) {
      return Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                }),
          ],
          title: Row(children: <Widget>[
            Container(
              child: Image.asset('images/logo.png'),
              height: 34.0,
            ),
            Text(
              ' Store Details',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ]),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Store name'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: locationController,
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Location'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: contactController,
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Contact'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: emailController,
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextButton(
                  onPressed: () {
                    _firestore.collection('stores').doc(song.songTitle).update({
                      'name': nameController.text,
                      'location': locationController.text,
                      'contact': contactController.text,
                      'email': emailController.text,
                    });
                    nameController.clear();
                    locationController.clear();
                    contactController.clear();
                    emailController.clear();
                  },
                  child: Text(
                    'Update',
                    style: kSendButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }));
  }
}
