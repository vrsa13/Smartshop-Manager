import 'package:flash_chat/screens/employees_screen.dart';
import 'package:flash_chat/screens/store_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'products_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/inventory_screen.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/models/model.dart';
import 'package:flash_chat/constants.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class LandingScreen extends StatefulWidget {
  static String id = 'landing_screen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _auth = FirebaseAuth.instance;

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

  void setStoreName() {
    _firestore.collection('stores').get().then((res) {
      res.docs.forEach((result) {
        _firestore.collection('stores').doc(result.id).get().then((value) {
          if (value.data()["uid"] == _auth.currentUser.uid) {
            final song = Provider.of<Song>(context, listen: false);
            song.updateSongTitle(result.id);
            //print(result.id);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setStoreName();
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
              ' Store Manager',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ]),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder(
                stream: _firestore
                    .collection('stores')
                    .doc(song.songTitle)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final x = snapshot.data.data();
                    print(x);
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(children: <Widget>[
                            Text(snapshot.data.data()["name"],
                                style: kDetailsTextStyle),
                            Text(snapshot.data.data()["location"],
                                style: kTableTextStyle),
                            Text(snapshot.data.data()["contact"],
                                style: kTableTextStyle),
                            Text(snapshot.data.data()["email"],
                                style: kTableTextStyle),
                          ]);
                        });
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Text("No data");
                  }
                  return LinearProgressIndicator();
                },
              ),
              SizedBox(
                height: 40.0,
              ),
              RoundedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ProductScreen.id);
                },
                title: 'Stock Products',
              ),
              RoundedButton(
                onPressed: () {
                  Navigator.pushNamed(context, InventoryScreen.id);
                },
                title: 'Inventory',
              ),
              RoundedButton(
                onPressed: () {
                  Navigator.pushNamed(context, EmployeesScreen.id);
                },
                title: 'Employees',
              ),
              RoundedButton(
                onPressed: () {
                  Navigator.pushNamed(context, StoreScreen.id);
                },
                title: 'Store Details',
              ),
            ],
          ),
        ),
      );
    }));
  }
}
