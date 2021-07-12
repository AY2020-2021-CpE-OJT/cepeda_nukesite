import 'dart:convert';
import 'package:pb_v5/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

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
  RegExp digitValidator = RegExp("[0-9]+");
  bool isANumber = true;

  TextEditingController firstNameCtrlr = TextEditingController();
  TextEditingController lastNameCtrlr = TextEditingController();

  List<TextEditingController> contactNumCtrlr = <TextEditingController>[
    TextEditingController()
  ];

  //final FocusNode firstNameNode = FocusNode();
  //final FocusNode lastNameNode = FocusNode();

  List<Contact> updatedContact = <Contact>[];
  String contactIdentifier = '';

  Future<http.Response> deleteContact(String id) {
    final snackBar = SnackBar(
      content: Text("Contact Deleted: " + id),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return http.delete(
        Uri.parse('https://nukesite-phonebook-api.herokuapp.com/delete/' + id));
  }

  Future<http.Response> uploadUpdated(
      String firstName, String lastName, List contactNumbers, String id) {
    return http.patch(
      Uri.parse('https://nukesite-phonebook-api.herokuapp.com/update/' + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'contact_numbers': contactNumbers,
      }),
      // RETURN ERROR CATCH
    );
  }

  void saveContact() {
    bool emptyDetect = false;
    List<String> listedContacts = <String>[];
    for (int i = 0; i < _count; i++) {
      listedContacts.add(contactNumCtrlr[i].text);
      if (contactNumCtrlr[i].text.isEmpty) {
        emptyDetect = true;
      }
    }
    setState(() {
      updatedContact.insert(
          0,
          Contact(firstNameCtrlr.text, lastNameCtrlr.text,
              listedContacts.reversed.toList()));
    });
    if (updatedContact[0].first_name.isEmpty ||
        updatedContact[0].last_name.isEmpty) {
      emptyDetect = true;
    }

    Text message = Text('Contact Updated: \n\n' +
        updatedContact[0].first_name +
        " " +
        updatedContact[0].last_name +
        "\n" +
        listedContacts.reversed.toList().toString());

    if (!emptyDetect) {
      uploadUpdated(
        updatedContact[0].first_name,
        updatedContact[0].last_name,
        listedContacts.reversed.toList(),
        contactIdentifier,
      );
    } else {
      message = Text(
        'Please Fill All Fields',
        style: TextStyle(color: Colors.red),
      );
    }

    final snackBar = SnackBar(
      content: message,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (!emptyDetect) {
      Navigator.pop(context);
    } else {
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
        backgroundColor: _color("black"),
        appBar: AppBar(
          centerTitle: true,
          title: _cText("Update Contact", _color('def'), null, null),
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
                    context,
                    "First Name",
                    /*widget.initialFirstName,*/
                    firstNameCtrlr,
                    _color('sel'),
                    _color('def'),
                    Colors.red),
                _hfill(10),
                ctrlrField(
                    context,
                    "Last Name",
                    /*widget.initialLastName,*/
                    lastNameCtrlr,
                    _color('sel'),
                    _color('def'),
                    Colors.red),
                _hfill(10),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(bottom: 8, left: 8),
                  child: Text("#s: $_count",
                      style: _idTextStyle('italic', Colors.grey, 12)),
                ),
                _hfill(5),
                Flexible(
                  child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: _count,
                      itemBuilder: (context, index) {
                        return _contactsInput(index, context);
                      }),
                ),
                _hfill(10),
                /*
              Container(
                alignment: Alignment.bottomRight,
                child: Text("Number of Contacts: $_count",
                    style: _idTextStyle('italic', Colors.grey, 15)),
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
              foregroundColor: Colors.white,
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
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal[900],
            ),
            SizedBox(width: 12),
            FloatingActionButton.extended(
              onPressed: () {
                // >>>>>>>>>>>>>>>>>>>>>>>>>>>> SAVE BUTTON HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                saveContact();
              },
              icon: Icon(Icons.save),
              label: Text("Save"),
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal[900],
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
            child: TextFormField(
              //maxLength: 12,
              controller: contactNumCtrlr[index],
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _color('sel'),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _color('def'),
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
                labelStyle: _idTextStyle('bold', _color('sel'), 15),
                //errorBorder:
              ),
              style: _idTextStyle('bold', _color('def'), 15),
            ),
          ),
        ],
      ),
      SizedBox(height: 12),
    ]);
  }

  Widget _hfill(double height) {
    return SizedBox(height: height);
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

Widget ctrlrField(
    BuildContext context,
    String fieldPrompt,
    //String initialValue,
    TextEditingController ctrlrID,
    Color selectedColor,
    Color defaultColor,
    Color errorColor) {
  return TextFormField(
    //initialValue: initialValue,
    controller: ctrlrID,
    textInputAction: TextInputAction.next,
    textCapitalization: TextCapitalization.sentences,
    //focusNode: currentNodeID,
    /*
    onFieldSubmitted: (term) {
      _fieldFocusChange(context, currentNodeID, nextNodeID);
    },*/
    decoration: new InputDecoration(
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: selectedColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: defaultColor,
        ),
      ),
      disabledBorder: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      labelText: fieldPrompt,
      labelStyle: _idTextStyle('bold', selectedColor, 15),
      //errorText: (ctrlrID.text.isEmpty) ? "Field is Required" : null,
    ),
    style: _idTextStyle('bold', defaultColor, 15),
  );
}

Color _color(String id) {
  switch (id) {
    case ('black'):
      return Colors.black;
    case ('lblue'):
      return Colors.lightBlue;
    case ('grey'):
      return Colors.grey;
    case ('def'):
      return Color(0xFFFFFFFF);
    case ('sel'):
      return Color(0xFF00ABFF);
    case ('sub'):
      return Color(0xFF6F6F6F);
    case ('high'):
      return Colors.deepOrange;
    default:
      print('colorNot Identifed');
      return Colors.white;
  }
}

Widget _cText(String text, Color? colour, double? size, String? style) {
  return Text(text, style: _idTextStyle(style, colour, size));
}

TextStyle _idTextStyle(String? style, Color? colour, double? size) {
  double defaultSize = 20;
  switch (style) {
    case 'bold':
      return TextStyle(
        color: (colour != null) ? colour : Colors.grey,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        fontSize: (size != null) ? size : defaultSize,
      );
    case 'italic':
      return TextStyle(
        color: (colour != null) ? colour : Colors.grey,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.normal,
        fontSize: (size != null) ? size : defaultSize,
      );
    case 'boldItalic':
      return TextStyle(
        color: (colour != null) ? colour : Colors.grey,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontSize: (size != null) ? size : defaultSize,
      );
    default:
      return TextStyle(
        color: (colour != null) ? colour : Colors.grey,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
        fontSize: (size != null) ? size : defaultSize,
      );
  }
}
