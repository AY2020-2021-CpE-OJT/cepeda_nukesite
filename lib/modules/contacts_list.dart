import 'package:flutter/material.dart';
import 'package:pb_v5/model/contact.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'contacts_import.dart';

class ContactList extends StatefulWidget {
  //ContactList({Key key}) : super(key: key);
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Contact> contactsList = [];

  void getContactsfromApi() async {
    ImportAPIContacts.getContacts().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        contactsList = list.map((model) => Contact.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getContactsfromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contacts"),
        ),
        body: Container(
          child: ListView.builder(
              itemCount: contactsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(contactsList[index].first_name),
                  subtitle: Text(contactsList[index].last_name),
                );
              }),
        ));
  }
}
