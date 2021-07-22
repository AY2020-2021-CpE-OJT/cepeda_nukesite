import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pb_v5/model/contact.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pb_v5/modules/add_contact.dart';
import 'package:pb_v5/modules/nuke.dart';
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
  String debug = "";
  int numdeBug = 0;

  List<PopupItem> menu = [
    PopupItem(1, "Log-in"),
    PopupItem(2, "Log-out"),
    //PopupItem(3, "DevTest-sp"),
    //PopupItem(4, "DevTest-sb"),
    //PopupItem(5, "DevTest-newGet"),
    PopupItem(0, "debugTesting"),
  ];
  String _selectedChoices = "none";
  void _select(String choice) {
    setState(() {
      _selectedChoices = choice;
    });
    switch (_selectedChoices) {
      case 'Log-in':
        loginTrigger();
        break;
      case 'Log-out':
        print("Log-out OTW");
        break;
      case 'DevTest-sp':
        prefSetup()
            .then((value) => {print("TOKEN FROM PREFERENCES: " + value!)});
        print(tokenStore.getString('token'));
        break;
      case 'DevTest-newGet':
        //newGet();
        break;
      case 'debugTesting':
        /*
        setState(() {
          numdeBug++;
        });*/

        disguisedToast(
          context: context,
          message: 'debugTesting' + debug,
          msgColor: colour(colour: 'red'),
          secDur: 3,
          callback: () async => setState(() {
            numdeBug++;
          }),
        );
        break;
      default:
        print(_selectedChoices);
        _selectedChoices = "none";
        print(_selectedChoices);
    }
  }

  Future<int> extractContacts() async {
    String retrievedToken = '';
    await prefSetup().then((value) =>
        {print("TOKEN FROM PREFERENCES: " + value!), retrievedToken = value});
    final response = await http.get(
      Uri.parse('https://nukesite-phonebook-api.herokuapp.com/all/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer " + retrievedToken
      },
    );
    print("RESPONSE BODY: " + response.body.toString());
    if (response.body.toString() == 'Forbidden') {
      disguisedToast(
          context: context, message: "Forbidden Access, Please Log-in...");
      setState(() {
        contactsList.clear();
      });
    } else {
      setState(() {
        Iterable list = json.decode(response.body);
        contactsList = list.map((model) => Contact.fromJson(model)).toList();
      });
    }
    return (response.statusCode);
  }

  Future<String?> prefSetup() async {
    tokenStore = await SharedPreferences.getInstance();
    if (tokenStore.getString('token') != null) {
      print(tokenStore.getString('token'));
      return tokenStore.getString('token');
    } else {
      print(tokenStore.getString('token'));
      tokenStore.setString('token', 'empty');
      return 'empty token';
    }
  }

  // TO_DO IMPLEMENT IN LOCAL
  Future<http.Response> deleteContact(String id) {
    return http.delete(
        Uri.parse('https://nukesite-phonebook-api.herokuapp.com/delete/' + id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colour(colour: 'dblue'),
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: cText(text: "Contacts " + numdeBug.toString()),
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
                                    //print("RETURNED VALUE" + value.toString());
                                    await Future.delayed(
                                        Duration(seconds: 2), () {});
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
                                    await Future.delayed(
                                        Duration(seconds: 3), () {});*/
                                    /*
                                    print(index.toString() + "/" +
                                        contactsList[index].first_name);*/
                                  },
                                  child: Card(
                                    color: Colors.black,
                                    shape: BeveledRectangleBorder(
                                        side: BorderSide(
                                            color: colour(colour: 'blue'),
                                            width: 1.5),
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
          FAB(
            onPressed: () => reloadList(),
            icon: Icon(Icons.refresh),
            text: "Refresh",
            background: colour(colour: 'dblue'),
          ),
          vfill(12),
          FAB(
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateNewContact()));
              setState(() {
                reloadList();
              });
            },
            icon: Icon(Icons.phone),
            text: "Add New",
            background: colour(colour: 'dblue'),
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
    disguisedToast(context: context, message: "Reloading...");
    extractContacts();
  }

  delayedLogin() async {
    await Future.delayed(Duration(seconds: 3), () {});
    //print("TOKEN DELAY:" + tokenStore.getString('token').toString());
    if (tokenStore.getString('token').toString().isEmpty ||
        tokenStore.getString('token').toString() == 'rejected') {
      final value = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      await Future.delayed(Duration(seconds: 3), () {});
      setState(() {
        reloadList();
      });
    }
  }

  loginTrigger() async {
    final value = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    await Future.delayed(Duration(seconds: 3), () {});
    setState(() {
      reloadList();
    });
  }
}
