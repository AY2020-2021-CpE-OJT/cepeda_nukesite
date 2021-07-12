import 'package:flutter/material.dart';
import 'package:pb_v5/model/contact.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pb_v5/modules/add_contact.dart';
import 'contacts_import.dart';

class Nuke extends StatefulWidget {
  @override
  _NukeState createState() => _NukeState();
}

class _NukeState extends State<Nuke> {
  final GlobalKey _menuKey = new GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final button = new PopupMenuButton(
        key: _menuKey,
        itemBuilder: (_) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                  child: const Text('Doge'), value: 'Doge'),
              new PopupMenuItem<String>(
                  child: const Text('Lion'), value: 'Lion'),
            ],
        onSelected: (_) {});

    final tile = new ListTile(
        title: new Text('Doge or lion?'),
        trailing: button,
        onTap: () {
          // This is a hack because _PopupMenuButtonState is private.
          dynamic state = _menuKey.currentState;
          state.showButtonMenu();
        });
    return new Scaffold(
      body: new Center(
        child: tile,
      ),
    );
  }
}
