import 'package:flutter/material.dart';
import 'package:smartshop_manager/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:smartshop_manager/models/model.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class InventoryScreen extends StatefulWidget {
  static const String id = 'inventory_screen';
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _auth = FirebaseAuth.instance;
  String name;
  String mrp;
  String category;

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
              ' Inventory',
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
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SingleChildScrollView(
                    child: Table(
                      defaultColumnWidth: FixedColumnWidth(90.0),
                      children: [
                        TableRow(
                          children: [
                            Text("Name", style: kTableTextStyle),
                            Text("Price", style: kTableTextStyle),
                            Text("Type", style: kTableTextStyle),
                            Text("Quantity", style: kTableTextStyle),
                            //Text(" ", style: kTableTextStyle),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ProductStream(can: song.songTitle),
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
          .collection('products')
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
        List<ProductBubble> productBubbles = [];
        for (var product in products) {
          final productText = product.get('name');
          final productPrice = product.get('mrp');
          final productType = product.get('category');
          final productQuantity = product.get('quantity');

          final productBubble = ProductBubble(
            name: productText,
            price: productPrice,
            type: productType,
            quantity: productQuantity,
          );

          productBubbles.add(productBubble);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: productBubbles,
          ),
        );
      },
    );
  }
}

class ProductBubble extends StatelessWidget {
  ProductBubble({this.name, this.price, this.type, this.quantity});

  final String name;
  final String price;
  final String type;
  final String quantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Table(
          defaultColumnWidth: FixedColumnWidth(90.0),
          border: TableBorder(
              top: BorderSide(color: Colors.grey, width: 1),
              bottom: BorderSide(color: Colors.grey, width: 1)),
          children: [
            TableRow(children: [
              Text(name, style: kTableTextStyle),
              Text(price, style: kTableTextStyle),
              Text(type, style: kTableTextStyle),
              Text(quantity, style: kTableTextStyle),
              // IconButton(icon: Icon(Icons.close), onPressed: () {
              //   _firestore
              //       .collection('stores')
              //       .doc(loggedInUser.email)
              //       .collection('products').doc().delete().then((_) {
              //     print("success!");
              //   });
              // }),
            ]),
          ]),
    );
  }
}
