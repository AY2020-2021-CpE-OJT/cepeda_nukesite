import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flushbar/flushbar.dart';
//import 'package:flushbar/flushbar_helper.dart';
//import 'dart:async';

Color colour({String? colour}) {
  switch (colour) {
    case ('black'):
      return Colors.black;
    case ('blue'):
      return Colors.blue;
    case ('lblue'):
      return Colors.lightBlue;
    case ('dblue'):
      return Color(0xFF01579B);
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
    case ('white'):
      return Colors.white;
    case ('red'):
      return Colors.red;
    case ('dred'):
      return Color(0xff500000);
    default:
      return Colors.white;
  }
}

Widget ctrlrField(
    {required BuildContext context,
    required String fieldPrompt,
    //String initialValue,
    required TextEditingController ctrlrID,
    Color? selectedColor,
    Color? defaultColor,
    Color? errorColor,
    TextInputType? inputType,
    bool? obscure = false,
    bool? autoFocus = false,
    bool? next}) {
  return TextFormField(
    //initialValue: initialValue,
    controller: ctrlrID,
    keyboardType: (inputType == null) ? TextInputType.text : inputType,
    obscureText: obscure!,
    autofocus: autoFocus!,
    //focusNode: focus,
    /*
    onFieldSubmitted: (v) {
      FocusScope.of(context).requestFocus();
    },*/
    textInputAction: (next!) ? TextInputAction.next : TextInputAction.done,
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
          color: (selectedColor != null) ? selectedColor : Colors.grey,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: (defaultColor != null) ? defaultColor : Colors.grey,
        ),
      ),
      disabledBorder: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      labelText: fieldPrompt,
      labelStyle: cxTextStyle(style: 'bold', colour: selectedColor, size: 15),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: (errorColor != null) ? errorColor : Colors.red,
        ),
      ),
      //errorText: (ctrlrID.text.isEmpty) ? "Field is Required" : null,
    ),
    style: cxTextStyle(style: 'bold', colour: defaultColor, size: 15),
  );
}

Widget cText({String? text, Color? colour, double? size, String? style}) {
  return Text((text != null) ? text : 'test_text',
      style: cxTextStyle(style: style, colour: colour, size: size));
}

TextStyle cxTextStyle({String? style, Color? colour, double? size}) {
  double defaultSize = 20;
  // DEFAULT GREY BECAUSE WHITE FADES IN WHITE BG, BLACK FADES IN BLACK BG
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

Widget hfill(double height) {
  return SizedBox(height: height);
}

Widget vfill(double width) {
  return SizedBox(width: width);
}

class PopupItem {
  int value;
  String name;
  PopupItem(this.value, this.name);
}

/*
List<PopupItem> selectables = [
  PopupItem(1, "ON"),
  PopupItem(2, "OFF")
];*/

class SelectionMenu extends StatelessWidget {
  SelectionMenu({required this.selectables, required this.onSelection});
  final Function(String) onSelection;
  final List<PopupItem> selectables;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        color: Colors.black,
        elevation: 20,
        enabled: true,
        icon: Icon(Icons.settings),
        onSelected: (value) => onSelection(value.toString()),
        itemBuilder: (context) {
          return selectables.map((PopupItem choice) {
            return PopupMenuItem(
              value: choice.name,
              child: Text(
                choice.name,
                style: cxTextStyle(style: 'bold', colour: colour(), size: 16),
              ),
            );
          }).toList();
        });
  }
}

class FAB extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon? icon;
  final String? text;
  final TextStyle? style;
  final Color? foreground, background;

  FAB(
      {required this.onPressed,
      this.icon,
      this.text,
      this.style,
      this.foreground,
      this.background});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        // >>>>>>>>>>>>>>>>>>>>>>>>>>>> CALLBACK BUTTON HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        onPressed();
      },
      icon: icon,
      label: Text((text != null) ? text! : 'Test',
          style: (style != null)
              ? style
              : cxTextStyle(colour: colour(), size: 16)),
      foregroundColor: (foreground != null) ? foreground : colour(),
      backgroundColor:
          (background != null) ? background : colour(colour: 'sel'),
    );
  }
}

void disguisedToast(
    {required BuildContext context,
    String? title,
    required String message,
    Color? msgColor,
    double? msgSize,
    String? button,
    Color? bgcolour,
    int? secDur,
    VoidCallback? atEnd,
    Function()? callback}) {
  Flushbar(
    margin: EdgeInsets.all(8),
    padding: EdgeInsets.all(10),
    borderRadius: 8,
    backgroundColor: (bgcolour != null) ? bgcolour : Colors.black87,
    mainButton: (callback != null)
        ? TextButton(
            child: Text(
              'Click Me',
              style: cxTextStyle(),
            ),
            onPressed: () async => callback,
          )
        : null,
    duration: Duration(seconds: (secDur == null) ? 3 : secDur),
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    // TO RENDER CUSTOMISABLE
    title: title,
    messageText: Text(
      message,
      style: cxTextStyle(style: 'bold', colour: msgColor, size: msgSize),
    ),
  )..show(context).then((value) => null);
}

/*  THIS DELAY ISN'T WORKING AS A METHOD BUT WORKS IF PUT IN CODE AS IT, NO PASS
void delay(int dur) async {
  await Future.delayed(Duration(seconds: dur), () {});
}*/

/*
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
      default:
        print(_selectedChoices);
        _selectedChoices = "none";
        print(_selectedChoices);d
        target = -1;
    }
  }*/
