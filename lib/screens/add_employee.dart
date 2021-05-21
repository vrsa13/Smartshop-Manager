import 'package:flutter/material.dart';
import 'package:smartshop_manager/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:smartshop_manager/models/model.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class AddEmployee extends StatefulWidget {
  static String id = 'add_employee';
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final nameTextController = TextEditingController();
  final idTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String name;
  String id;

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
              ' Add Employees',
              style: TextStyle(
                fontSize: 30.0,
                //fontWeight: FontWeight.w900,
              ),
            ),
          ]),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: nameTextController,
                  onChanged: (value) {
                    name = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Employee name'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: idTextController,
                  onChanged: (value) {
                    id = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Employee ID'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextButton(
                  onPressed: () {
                    nameTextController.clear();
                    idTextController.clear();
                    _firestore
                        .collection('stores')
                        .doc(song.songTitle)
                        .collection('employees')
                        .add({
                      'name': name,
                      'id': id,
                    });
                  },
                  child: Text(
                    'Send',
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
