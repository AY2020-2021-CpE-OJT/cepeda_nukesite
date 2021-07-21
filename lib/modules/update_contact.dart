import 'dart:convert';
import 'dart:io';
import 'package:pb_v5/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dev.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateContact extends StatefulWidget {
  final String initialFirstName, initialLastName, contactID;
  final List<String> initialContacts;
  const UpdateContact({
    Key? key,
    required this.initialFirstName,
    required this.initialLastName,
    required this.initialContacts,
    required this.contactID,
    /*CONTACTS*/
  }) : super(key: key);
  @override
  _UpdateContactState createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  int key = 0, increments = 0, contactsSize = 1, _count = 1;
  late SharedPreferences tokenStore;

  TextEditingController firstNameCtrlr = TextEditingController();
  TextEditingController lastNameCtrlr = TextEditingController();

  List<TextEditingController> contactNumCtrlr = <TextEditingController>[
    TextEditingController()
  ];

  late Contact updatedContact;
  String contactIdentifier = '';

  Future<http.Response> deleteContact(String id) {
    final snackBar = SnackBar(
      content: Text("Contact Deleted: " + id),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return http.delete(
        Uri.parse('https://nukesite-phonebook-api.herokuapp.com/delete/' + id));
  }

  Future<int> uploadUpdated(
      String firstName, String lastName, List contactNumbers, String id) async {
    String retrievedToken = '';
    await prefSetup().then((value) =>
        {print("TOKEN FROM PREFERENCES: " + value!), retrievedToken = value});
    final response = await http.patch(
      Uri.parse('https://nukesite-phonebook-api.herokuapp.com/update/' + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer " + retrievedToken
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'contact_numbers': contactNumbers,
      }),
    );
    return (response.statusCode);
  }

  Future<String?> prefSetup() async {
    tokenStore = await SharedPreferences.getInstance();
    return tokenStore.getString('token');
  }

  void saveContact() async {
    int statusCode = 0;
    bool emptyDetect = false;
    List<String> listedContacts = <String>[];
    for (int i = 0; i < _count; i++) {
      listedContacts.add(contactNumCtrlr[i].text);
      if (contactNumCtrlr[i].text.isEmpty) {
        emptyDetect = true;
      }
    }
    setState(() {
      updatedContact = new Contact(firstNameCtrlr.text, lastNameCtrlr.text,
          listedContacts.reversed.toList());
    });
    if (updatedContact.first_name.isEmpty || updatedContact.last_name.isEmpty) {
      emptyDetect = true;
    }

    Text message = Text('Contact Updating: \n\n' +
        updatedContact.first_name +
        " " +
        updatedContact.last_name +
        "\n" +
        listedContacts.reversed.toList().toString());

    if (!emptyDetect) {
      statusCode = await uploadUpdated(
        updatedContact.first_name,
        updatedContact.last_name,
        listedContacts.reversed.toList(),
        contactIdentifier,
      );
      print(statusCode);
      //return statusCode;
    } else {
      message = Text(
        'Please Fill All Fields',
        style:
            cxTextStyle(style: 'bold', colour: colour(colour: 'red'), size: 15),
      );
    }

    final snackBar = SnackBar(
      content: message,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if ((statusCode == 200) || (statusCode == 403)) {
      Navigator.pop(context, statusCode);
    } else if (emptyDetect) {
      emptyDetect = false;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _count = 0;
      firstNameCtrlr = TextEditingController(text: widget.initialFirstName);
      lastNameCtrlr = TextEditingController(text: widget.initialLastName);
      contactIdentifier = widget.contactID;
      List<String> contactsToDisplay = <String>[];
      contactsToDisplay = widget.initialContacts;
      print("IN:" + widget.initialContacts.length.toString());
      final int edge = widget.initialContacts.length;
      for (int i = 0; i < edge; i++) {
        contactsToDisplay.add(widget.initialContacts[i]);
        if (i < edge) {
          contactNumCtrlr.insert(
              0, TextEditingController(text: widget.initialContacts[i]));
        }
        _count++;
        print("i: " +
            i.toString() +
            " / _count: " +
            _count.toString() +
            " / inserted: " +
            widget.initialContacts[i]);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colour(colour: 'black'),
        appBar: AppBar(
          centerTitle: true,
          title: cText(text: "Update Contact", colour: colour()),
          actions: [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  key = 0;
                  increments = 0;
                  contactsSize = 1;
                  _count = 1;
                  firstNameCtrlr.clear();
                  lastNameCtrlr.clear();
                  contactNumCtrlr.clear();
                  contactNumCtrlr = <TextEditingController>[
                    TextEditingController()
                  ];
                });
              },
            )
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ctrlrField(
                    context: context,
                    fieldPrompt: "First Name",
                    ctrlrID: firstNameCtrlr,
                    defaultColor: colour(),
                    selectedColor: colour(colour: 'sel'),
                    next: true,
                    autoFocus: false),
                hfill(10),
                ctrlrField(
                    context: context,
                    fieldPrompt: "Last Name",
                    ctrlrID: lastNameCtrlr,
                    defaultColor: colour(),
                    selectedColor: colour(colour: 'sel'),
                    next: true,
                    autoFocus: false),
                hfill(10),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(bottom: 8, left: 8),
                  child: Text("#s: $_count",
                      style: cxTextStyle(
                          style: 'italic', colour: Colors.grey, size: 12)),
                ),
                hfill(5),
                Flexible(
                  child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: _count,
                      itemBuilder: (context, index) {
                        return _contactsInput(index, context);
                      }),
                ),
                hfill(10),
                /*
              Container(
                alignment: Alignment.bottomRight,
                child: Text("Number of Contacts: $_count",
                    style: cxTextStyle('italic', Colors.grey, 15)),
              ),
              //Text(_result),*/
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton.extended(
              onPressed: () {
                // >>>>>>>>>>>>>>>>>>>>>>>>>>>> DELETE BUTTON HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                deleteContact(contactIdentifier);
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete_forever),
              label: Text("Delete"),
              foregroundColor: colour(),
              backgroundColor: Colors.red[900],
            ),
            SizedBox(width: 12),
            FloatingActionButton.extended(
              onPressed: () {
                // >>>>>>>>>>>>>>>>>>>>>>>>>>>> ADD BUTTON HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                setState(() {
                  _count++;
                  increments++;
                  contactsSize++;
                  contactNumCtrlr.insert(0, TextEditingController());
                });
              },
              icon: Icon(Icons.add),
              label: Text("Add"),
              foregroundColor: colour(),
              backgroundColor: colour(colour: 'dblue'),
            ),
            SizedBox(width: 12),
            FloatingActionButton.extended(
              onPressed: () {
                // >>>>>>>>>>>>>>>>>>>>>>>>>>>> SAVE BUTTON HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                saveContact();
              },
              icon: Icon(Icons.save),
              label: Text("Save"),
              foregroundColor: colour(),
              backgroundColor: colour(colour: 'dblue'),
            ),
          ],
        ),
        persistentFooterButtons: <Widget>[]);
  }

  _contactsInput(int index, context) {
    return Column(children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              width: 24,
              height: 24,
              child: _removeButton(index),
            ),
          ),
          Expanded(
            child: ctrlrField(
                context: context,
                fieldPrompt: "Contact Number",
                ctrlrID: contactNumCtrlr[index],
                defaultColor: colour(),
                selectedColor: colour(colour: 'sel'),
                next: true,
                autoFocus: true,
                inputType: TextInputType
                    .phone), /*TextFormField(
              //maxLength: 12,
              controller: contactNumCtrlr[index],
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: color('sel'),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: color('def'),
                  ),
                ),

                disabledBorder: InputBorder.none,
                /*
                  errorText: (contactNumCtrlr[index].text.isNotEmpty)
                  ? null
                  : "Please enter a number",
                   errorBorder: OtlinedInputBorder, */
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                labelText: 'Contact Number',
                labelStyle: cxTextStyle('bold', color('sel'), 15),
                //errorBorder:
              ),
              style: cxTextStyle('bold', color('def'), 15),
            ),*/
          ),
        ],
      ),
      SizedBox(height: 12),
    ]);
  }

  Widget _removeButton(int index) {
    return InkWell(
      onTap: () {
        //FocusManager.instance.primaryFocus?.unfocus();
        if (_count != 1) {
          setState(() {
            _count--;
            increments--;
            contactsSize--;
            contactNumCtrlr.removeAt(index);
          });
        }
      },
      child: (_count != 1)
          ? Container(
              alignment: Alignment.center,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.cancel,
                color: Colors.white70,
              ),
            )
          : null,
    );
  }
}
