import 'package:smartshop_manager/screens/add_employee.dart';
import 'package:flutter/material.dart';
import 'package:smartshop_manager/constants.dart';
import 'package:smartshop_manager/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:smartshop_manager/models/model.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class EmployeesScreen extends StatefulWidget {
  static String id = 'employees_screen';
  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
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
              ' Employees',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ]),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8.0),
                child: SingleChildScrollView(
                  child: Table(
                    defaultColumnWidth: FixedColumnWidth(200.0),
                    children: [
                      TableRow(
                        children: [
                          Text(
                            'Name',
                            style: kTableTextStyle,
                          ),
                          Text(
                            'ID',
                            style: kTableTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ProductStream(can: song.songTitle),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: RoundedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AddEmployee.id);
                  },
                  title: 'Add Employee',
                ),
              ),
              // RoundedButton(
              //   onPressed: () {
              //     Navigator.pushNamed(context, AddEmployee.id);
              //   },
              //   title: 'Edit Employee',
              // ),
            ],
          ),
        ),
      );
    }));
  }
}

class ProductStream extends StatelessWidget {
  String can;
  ProductStream({this.can});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('stores')
          .doc(this.can)
          .collection('employees')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final products = snapshot.data.docs;
        List<EmployeeBubble> productBubbles = [];
        for (var product in products) {
          final employeeName = product.get('name');
          final employeeId = product.get('id');

          final employeeBubble = EmployeeBubble(
            name: employeeName,
            id: employeeId,
          );

          productBubbles.add(employeeBubble);
        }
        return Expanded(
          child: ListView(
            children: productBubbles,
          ),
        );
      },
    );
  }
}

class EmployeeBubble extends StatelessWidget {
  EmployeeBubble({this.name, this.id});

  final String name;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8.0),
      child: Table(
          defaultColumnWidth: FixedColumnWidth(200.0),
          border: TableBorder(
              top: BorderSide(color: Colors.grey, width: 1),
              bottom: BorderSide(color: Colors.grey, width: 1)),
          children: [
            TableRow(children: [
              Text(name, style: kTableTextStyle),
              Text(id, style: kTableTextStyle),
            ]),
          ]),
    );
  }
}
