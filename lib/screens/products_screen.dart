import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/models/model.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ProductScreen extends StatefulWidget {
  static String id = 'products_screen';
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _auth = FirebaseAuth.instance;
  String name;
  String mrp;
  String category;
  String quantity;
  String aisle;
  String barcode;
  String desc;
  String brand;
  String image;
  TextEditingController nameController = TextEditingController();
  TextEditingController mrpController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController aisleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();

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
              ' Products',
              style: TextStyle(
                fontSize: 30.0,
                //fontWeight: FontWeight.w900,
              ),
            ),
          ]),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 50.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Add products to inventory',
                    style: kDetailsTextStyle,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    onChanged: (value) {
                      barcode = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter barcode'),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore
                          .collection("products")
                          .doc(barcode)
                          .get()
                          .then((value) {
                        nameController.text = value.data()["name"];
                        mrpController.text = value.data()["mrp"];
                        categoryController.text = value.data()["category"];
                        descController.text = value.data()["description"];
                        brandController.text = value.data()["brand"];
                        imageController.text =
                            value.data()["productImageLocation"];
                        barcodeController.text = value.data()["barcode"];
                      });
                    },
                    child: Text(
                      'Get',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    decoration:
                        kTextFieldDecoration.copyWith(hintText: 'Product name'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: mrpController,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Product price'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: categoryController,
                    decoration:
                        kTextFieldDecoration.copyWith(hintText: 'Product type'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: descController,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter description'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: brandController,
                    decoration:
                        kTextFieldDecoration.copyWith(hintText: 'Enter brand'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: imageController,
                    decoration:
                        kTextFieldDecoration.copyWith(hintText: 'Enter image'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: quantityController,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter quantity'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: aisleController,
                    decoration:
                        kTextFieldDecoration.copyWith(hintText: 'Enter aisle'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore
                          .collection('stores')
                          .doc(song.songTitle)
                          .collection('products')
                          .doc(barcode)
                          .set({
                        'barcode': barcodeController.text,
                        'name': nameController.text,
                        'brand': brandController.text,
                        'mrp': mrpController.text,
                        'category': categoryController.text,
                        'description': descController.text,
                        'quantity': quantityController.text,
                        'aisle': aisleController.text,
                        'productImageLocation': imageController.text,
                      });
                      nameController.clear();
                      mrpController.clear();
                      categoryController.clear();
                      quantityController.clear();
                      aisleController.clear();
                      barcodeController.clear();
                      imageController.clear();
                      brandController.clear();
                      descController.clear();
                    },
                    child: Text(
                      'Add',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }));
  }
}
