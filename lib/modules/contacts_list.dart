import 'package:flutter/material.dart';
import 'package:pb_v5/model/contact.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pb_v5/modules/add_contact.dart';
import 'package:pb_v5/modules/nuke.dart';
import 'contacts_import.dart';
import 'update_contact.dart';
import 'dev.dart';

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Contact> contactsList = [];
  var target = -1;
  List<String> choices = <String>[
    "Index",
    "Update",
    "Delete",
  ];
  String _selectedChoices = "none";

  void extractContacts() async {
    ImportAPIContacts.getContacts().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        contactsList = list.map((model) => Contact.fromJson(model)).toList();
      });
    });
  }

  Future<http.Response> deleteContact(String id) {
    print("Status Deleted [" + id + "]");
    return http.delete(
        Uri.parse('https://nukesite-phonebook-api.herokuapp.com/delete/' + id));
  }

  void _select(String choice) {
    setState(() {
      _selectedChoices = choice;
    });
    print("Onstart: " + target.toString());
    switch (_selectedChoices) {
      case 'Nuke':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Nuke()));
        break;
      case 'Update':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Nuke()));
        break;
      case 'Delete':
        deleteContact(contactsList[target].id);
        setState(() {
          target = 0;
          reloadList();
        });
        break;
      case 'Index':
        print("Onrun: " + target.toString());
        target = -1;
        print("AftRun: " + target.toString());
        break;
      default:
        _selectedChoices = "none";
        target = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: Text("Contacts"),
        actions: [],
      ),
      body: Container(
          padding: EdgeInsets.only(bottom: 60),
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: FutureBuilder<List<Contact>>(builder: (context, snapshot) {
            return contactsList.length != 0
                ? RefreshIndicator(
                    child: new SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 100),
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        child: ListView.builder(
                            key: UniqueKey(),
                            padding: EdgeInsetsDirectional.all(10), // MARK
                            itemCount: contactsList.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () async {
                                    final value = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UpdateContact(
                                                  initialFirstName:
                                                      contactsList[index]
                                                          .first_name,
                                                  initialLastName:
                                                      contactsList[index]
                                                          .last_name,
                                                  initialContacts: contactsList[
                                                          index]
                                                      .contact_numbers
                                                      .map((s) => s as String)
                                                      .toList(),
                                                  contactID: contactsList[index]
                                                      .id
                                                      .toString(),
                                                )));
                                    setState(() {
                                      reloadList();
                                    });
                                    /*
                                    print(index.toString() + "/" +
                                        contactsList[index].first_name);*/
                                  },
                                  child: Card(
                                    color: Colors.black,
                                    shape: BeveledRectangleBorder(
                                        side: BorderSide(
                                            color: color('blue'), width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          title: Text(
                                              contactsList[index].first_name +
                                                  ' ' +
                                                  contactsList[index].last_name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        _contactsOfIndex(index),
                                      ],
                                    ),
                                  ));
                            })),
                    onRefresh: reloadList,
                  )
                : Center(child: CircularProgressIndicator());
          })),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            onPressed: () {
              // >>>>>>>>>>>>>>>>>>>>>>>>>>>> REFRESH BUTTON HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
              reloadList();
            },
            icon: Icon(Icons.refresh),
            label: Text(
              "Refresh",
            ),
            foregroundColor: color('white'),
            backgroundColor: color('dblue'),
          ),
          SizedBox(width: 12),
          FloatingActionButton.extended(
            onPressed: () async {
              final value = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateNewContact()));
              setState(() {
                reloadList();
              });
            },
            icon: Icon(Icons.phone),
            label: Text("Add New"),
            foregroundColor: color('white'),
            backgroundColor: color('dblue'),
          ),
        ],
      ),
    );
  }

  Widget _contactsOfIndex(int index) {
    List<String> temp = contactsList[index].contact_numbers.cast<String>();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: temp.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int contactsIndex) {
          return Padding(
            padding: EdgeInsets.only(left: 24, bottom: 16),
            child: Text(temp[contactsIndex],
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                )),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    extractContacts();
  }

  Future<void> reloadList() async {
    extractContacts();
  }
}
