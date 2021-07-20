import 'dart:convert';
import 'package:pb_v5/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dev.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class User {
  final String username;
  final String password;

  User(this.username, this.password);

  Map toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameCtrlr = TextEditingController();
  final passwordCtrlr = TextEditingController();

  User user = new User("", "");

  Future<http.Response> uploadUser(String username, String password) async {
    print("ABOUT TO SEND");
    final response = await http.post(
      Uri.parse(
          /*'http://localhost:2077/login_nuke'*/ 'https://nukesite-phonebook-api.herokuapp.com/login_nuke'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    print(json.decode(response.body)['token']);
    SharedPreferences tokenStore = await SharedPreferences.getInstance();
    tokenStore.setString('token', json.decode(response.body)['token']);
    //print(tokenStore);

    print("STORED TOKEN: " + tokenStore.getString('token').toString());
    return response;
  }

  void saveUser() {
    bool emptyDetect = false;

    setState(() {
      user = new User(usernameCtrlr.text, passwordCtrlr.text);
    });
    if (user.username.isEmpty || user.password.isEmpty) {
      emptyDetect = true;
    }

    Text message =
        Text('User : ' + user.username + ' / ' + 'Password : ' + user.password);

    if (!emptyDetect) {
      uploadUser(
        user.username,
        user.password,
      );
    } else {
      message = Text(
        'Please Fill All Fields',
        style: cxTextStyle('bold', Colors.deepOrange, 16),
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
  }

  @override
  void dispose() {
    usernameCtrlr.dispose();
    passwordCtrlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color("black"),
      appBar: AppBar(
        centerTitle: true,
        title: cText("Create New", color('def'), null, null),
        actions: [
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                usernameCtrlr.clear();
                passwordCtrlr.clear();
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
                  fieldPrompt: "User Name",
                  ctrlrID: usernameCtrlr,
                  defaultColor: color('def'),
                  selectedColor: color('sel'),
                  errorColor: Colors.red,
                  next: true,
                  autoFocus: true),
              hfill(10),
              ctrlrField(
                  context: context,
                  fieldPrompt: "Password",
                  ctrlrID: passwordCtrlr,
                  defaultColor: color('def'),
                  selectedColor: color('sel'),
                  errorColor: Colors.red,
                  obscure: true,
                  next: true,
                  autoFocus: true),
              hfill(10),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(width: 12),
          FloatingActionButton.extended(
            onPressed: () {
              // >>>>>>>>>>>>>>>>>>>>>>>>>>>> SAVE BUTTON HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
              saveUser();
            },
            icon: Icon(Icons.login),
            label: Text("Log-in"),
            foregroundColor: color('white'),
            backgroundColor: color('dblue'),
          ),
        ],
      ),
    );
  }
}
