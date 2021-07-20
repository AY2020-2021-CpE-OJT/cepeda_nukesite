import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:flushbar/flushbar.dart';
//import 'package:flushbar/flushbar_helper.dart';
//import 'dart:async';

Color color(String id) {
  switch (id) {
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
      print('colorNot Identifed');
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
      labelStyle: cxTextStyle('bold', selectedColor, 15),
      //errorText: (ctrlrID.text.isEmpty) ? "Field is Required" : null,
    ),
    style: cxTextStyle('bold', defaultColor, 15),
  );
}

Widget cText(String text, Color? colour, double? size, String? style) {
  return Text(text, style: cxTextStyle(style, colour, size));
}

TextStyle cxTextStyle(String? style, Color? colour, double? size) {
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
                style: cxTextStyle('bold', color('white'), 16),
              ),
            );
          }).toList();
        });
  }
}

/*
void disguisedToast({
  required BuildContext context,
  String? title,
  required String message,
  Color? msgColor,
  double? msgSize,
  String? button,
  Color? bgcolor,
  int? secDur,
  VoidCallback? atEnd,
  /*VoidCallback? callback}*/
}) {
  Flushbar(
    margin: EdgeInsets.all(8),
    padding: EdgeInsets.all(10),
    borderRadius: 8,
    backgroundColor: (bgcolor != null) ? bgcolor : Colors.black87,
    /* TO FINISH DEVELOPMENT
    mainButton: TextButton(
      child: Text(
        'Click Me',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => callback,
    ),*/
    duration: Duration(seconds: (secDur == null) ? 3 : secDur),
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    // TO RENDER CUSTOMISABLE
    title: title,
    messageText: Text(
      message,
      style: cxTextStyle('bold', msgColor, msgSize),
    ),
  )..show(context).then((r) => atEnd);
}*/
/*
void delay(int dur) async {
  await Future.delayed(Duration(seconds: dur), () {});
}*/
/*
class DisguisedToast {
  DisguisedToast({
    required this.context,
    required this.message,
  });
  final String message;
  final BuildContext context;
  show(BuildContext context) {
    Flushbar(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(10),
      borderRadius: 8,
      backgroundGradient: LinearGradient(
        colors: [Colors.green.shade800, Colors.greenAccent.shade700],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      // All of the previous Flushbars could be dismissed by swiping down
      // now we want to swipe to the sides
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      // The default curve is Curves.easeOut
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: 'This is a floating Flushbar',
      message: message,
    )..show(context);
  }
}*/

/*
class GlobalSnackBar {
  final String message;
  final String? button;
  final Color? buttonColor;

  GlobalSnackBar({
    required this.message,
    this.button,
    this.buttonColor,
  });
  show(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0.0,
        //behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: new Duration(seconds: 5000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        //backgroundColor: Colors.redAccent,
        action: (button!=null)? SnackBarAction(
          textColor: Color(0xFFFAF2FB),
          label: button!,
          onPressed: () {/*BUTTON CALLBACK HERE*/ },
        ): null,
      ),
    );
  }
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
        print(_selectedChoices);
        target = -1;
    }
  }*/
