import 'package:flutter/material.dart';
import 'model/contact.dart';
import 'modules/contacts_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts',
      theme: ThemeData(
        primaryColor: Colors.black,
        primarySwatch: Colors.grey,
      ),
      home: ContactList(),
    );
  }
}
