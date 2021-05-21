import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
  color: Colors.white,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1.0, color: Colors.blueGrey),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2.0, color: Colors.blueGrey),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kTableTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18.0,
);

const kDetailsTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
);
