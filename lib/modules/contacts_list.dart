import 'package:flutter/material.dart';
import 'package:pb_v5/model/contact.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pb_v5/modules/add_contact.dart';
import 'package:pb_v5/modules/nuke.dart';
import 'contacts_import.dart';
import 'update_contact.dart';
import 'dev.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late SharedPreferences tokenStore;
  List<Contact> contactsList = [];
  var target = -1;
  List<PopupItem> menu = [
    PopupItem(1, "Log-in"),
    PopupItem(2, "Log-out"),
    PopupItem(3, "DevTest-sp"),
    PopupItem(4, "DevTest-sb"),
  ];
  String _selectedChoices = "none";
  void _select(String choice) {
    setState(() {
      _selectedChoices = choice;
    });
    //print("Onstart: " + target.toString());
    switch (_selectedChoices) {
      case 'Log-in':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
      case 'Log-out':
        print("Log-out OTW");
        break;
      case 'DevTest-sp':
        prefSetup()
            .then((value) => {print("TOKEN FROM PREFERENCES: " + value!)});
        print(tokenStore.getString('token'));
        break;
      case 'DevTest-sb':
        function() async {
          await Future.delayed(Duration(seconds: 3), () {});
          disguisedToast(
            context: context,
            message: 'TESTING FLUSHBAR',
            msgColor: color('red'),
            secDur: 2,
          );
        }
        function();
        break;
      default:
        print(_selectedChoices);
        _selectedChoices = "none";
        print(_selectedChoices);
        target = -1;
    }
  }

  void extractContacts() async {
    ImportAPIContacts.getContacts().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        contactsList = list.map((model) => Contact.fromJson(model)).toList();
      });
    });
  }

  // TO_DO IMPLEMENT IN LOCAL
  Future<http.Response> deleteContact(String id) {
    print("Status Deleted [" + id + "]");
    return http.delete(
        Uri.parse('https://nukesite-phonebook-api.herokuapp.com/delete/' + id));
  }
  /*
  void _select(String choice) {
    setState(() {
      _selectedChoices = choice;
    });
    print("Onstart: " + target.toString());
    switch (_selectedChoices) {
      case 'Nuke':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
      case 'Update':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: Text("Contacts"),
        actions: [
          SelectionMenu(
            selectables: menu,
            onSelection: (String value) => setState(() {
              _select(value);
            }),
          )
        ],
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
                                    // >>>>>>>>>>>>>>>>>>>>>>>>>>>> PUSH TO NEXT UPDATE SCREEN HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
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
                                    print("RETURNED VALUE" + value.toString());
                                    await Future.delayed(
                                        Duration(seconds: 5), () {});
                                    if (value == 403) {
                                      disguisedToast(
                                          context: context,
                                          message:
                                              "Forbidden Access, Please Log-In");
                                    } else if (value == 200) {
                                      disguisedToast(
                                          context: context,
                                          message: "Successful Update");
                                    } else {
                                      disguisedToast(
                                          context: context,
                                          message:
                                              "Something else happened\n Error Code: " +
                                                  value.toString());
                                    }
                                    await Future.delayed(
                                        Duration(seconds: 3), () {});
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
    prefSetup();
    delayedLogin();
  }

  Future<void> reloadList() async {
    extractContacts();
    disguisedToast(context: context, message: "Reloading...");
  }

  Future<String?> prefSetup() async {
    tokenStore = await SharedPreferences.getInstance();
    return tokenStore.getString('token');
  }

  delayedLogin() async {
    await Future.delayed(Duration(seconds: 3), () {});
    print("TOKEN DELAY:" + tokenStore.getString('token').toString());
    if (tokenStore.getString('token').toString().isEmpty ||
        tokenStore.getString('token').toString() == 'rejected') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
