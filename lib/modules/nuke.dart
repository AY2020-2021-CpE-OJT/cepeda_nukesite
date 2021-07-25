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
    disguisedToast(
        context: context, message: 'Logging in as ' + user.username, secDur: 1);
    await Future.delayed(Duration(seconds: 2), () {});
    String authCode = 'Basic ' +
        base64Encode(utf8.encode(user.username + ':' + user.password));
    print(authCode);
    final response = await http.post(
      Uri.parse(
          /*'http://localhost:2077/login_nuke'*/ 'https://nukesite-phonebook-api.herokuapp.com/login_new'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': authCode,
      },
      /*
      body: jsonEncode({
        'username': username,
        'password': password,
      }),*/
    );
    print(json.decode(response.body)['token']);
    SharedPreferences tokenStore = await SharedPreferences.getInstance();
    tokenStore.setString('token', json.decode(response.body)['token']);
    //print(tokenStore);

    print("STORED TOKEN: " + tokenStore.getString('token').toString());
    return (response);
  }

  Future<void> saveUser() async {
    bool emptyDetect = false;
    String responseToken = '';
    int statusCode = 0;

    setState(() {
      user = new User(usernameCtrlr.text, passwordCtrlr.text);
    });
    if (user.username.isEmpty || user.password.isEmpty) {
      emptyDetect = true;
    }

    Text message =
        Text('User : ' + user.username + ' / ' + 'Password : ' + user.password);

    if (!emptyDetect) {
      var response = await uploadUser(
        user.username,
        user.password,
      );
      //print(json.decode(response.body)['token']);
      statusCode = response.statusCode;
      responseToken = json.decode(response.body)['token'];
      await Future.delayed(Duration(seconds: 2), () {});
      if (responseToken == 'rejected') {
        disguisedToast(
            context: context,
            message: 'Access Forbidden,\nPlease Enter Correct Credentials');
      } else if (statusCode == 200) {
        disguisedToast(
            context: context,
            message: 'Login Successful',
            messageStyle: cxTextStyle(colour: colour('blue')),
            secDur: 2);
        await Future.delayed(Duration(seconds: 3), () {});
        setState(() {
          Navigator.pop(context);
        });
      } else if (statusCode != 200) {
        disguisedToast(
            context: context,
            message: 'Something else happened: ' + statusCode.toString());
      }
    } else {
      disguisedToast(
        context: context,
        message: 'Please fill all fields ',
        messageStyle: cxTextStyle(colour: colour('lred')),
      );
    }
    //await Future.delayed(Duration(seconds: 3), () {});
    if (!emptyDetect) {
      /*
      setState(() {
        Navigator.pop(context);
      });*/ ///
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
      backgroundColor: colour('black'),
      appBar: AppBar(
        centerTitle: true,
        title: cText(text: "Log-in", colour: colour('')),
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
          padding: const EdgeInsets.only(top: 90, right: 30, left: 30),
          child: Column(
            children: [
              ctrlrField(
                  context: context,
                  fieldPrompt: "User Name",
                  ctrlrID: usernameCtrlr,
                  defaultColor: colour(''),
                  selectedColor: colour('sel'),
                  errorColor: Colors.red,
                  next: true,
                  autoFocus: true),
              hfill(10),
              ctrlrField(
                  context: context,
                  fieldPrompt: "Password",
                  ctrlrID: passwordCtrlr,
                  defaultColor: colour(''),
                  selectedColor: colour('sel'),
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
            foregroundColor: colour(''),
            backgroundColor: colour('dblue'),
          ),
        ],
      ),
    );
  }
}
