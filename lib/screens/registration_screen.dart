import 'package:flutter/material.dart';
import 'package:smartshop_manager/components/rounded_button.dart';
import 'package:smartshop_manager/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartshop_manager/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:smartshop_manager/models/model.dart';

final _firestore = FirebaseFirestore.instance;

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String store;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                store = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter store name'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              onPressed: () async {
                final song = Provider.of<Song>(context, listen: false);
                song.updateSongTitle(store);
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  _firestore.collection('stores').doc(store).set({
                    'name': store,
                    'location': 'default',
                    'email': email,
                    'contact': 'default',
                    'uid': _auth.currentUser.uid,
                  });
                  _firestore
                      .collection('users')
                      .doc(_auth.currentUser.uid)
                      .set({
                    'name': store,
                    'email': email,
                    'uid': _auth.currentUser.uid,
                    'userType': 'store',
                    'isAuthorised': false,
                    'createdOn': DateTime.now(),
                    'approvedOn': "",
                  });
                  if (newUser != null) {
                    Navigator.pushNamed(context, LoginScreen.id);
                  }
                } catch (e) {
                  print(e);
                }
              },
              title: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
