import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:dbcrypt/dbcrypt.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar.dart';
//import 'package:another_flushbar/flushbar_helper.dart';
//import 'package:another_flushbar/flushbar_route.dart';
//import 'package:crypto/crypto.dart';
//import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:overlay_support/overlay_support.dart';

//import 'package:flushbar/flushbar_helper.dart';
//import 'dart:async';

Color colour(String? colour) {
  switch (colour) {
    case ('lred'):
      return Colors.red;
    case ('red'):
      return Color(0xff801010);
    case ('dred'):
      return Color(0xff500000);
    case ('orange'):
      return Colors.orange;
    case ('yellow'):
      return Colors.yellow;
    case ('green'):
      return Colors.green;
    case ('lblue'):
      return Colors.lightBlue;
    case ('blue'):
      return Colors.blue;
    case ('dblue'):
      return Color(0xFF01579B);
    case ('black'):
      return Colors.black;
    case ('grey'):
      return Colors.grey;
    case ('white'):
      return Colors.white;
    case ('def'):
      return Color(0xFFFFFFFF);
    case ('sel'):
      return Color(0xFF00ABFF);
    case ('sub'):
      return Color(0xFF6F6F6F);
    // CUSTOM PALLETTE
    case ('xblue'):
      return Color(0xFF00A8DB);
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
    bool? next,
    Function(String)? onChangeString}) {
  return TextFormField(
    //initialValue: initialValue,
    onChanged: (value) {
      if (onChangeString != null) {
        onChangeString(value);
      }
    },
    controller: ctrlrID,
    keyboardType: (inputType == null) ? TextInputType.text : inputType,
    obscureText: (obscure == null) ? false : obscure,
    autofocus: (autoFocus == null) ? false : autoFocus,
    //focusNode: focus,
    /*
    onFieldSubmitted: (v) {
      FocusScope.of(context).requestFocus();
    },*/
    textInputAction: (next != null && next == true)
        ? TextInputAction.next
        : TextInputAction.done,
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
        color: (colour != null) ? colour : Colors.white,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        fontSize: (size != null) ? size : defaultSize,
      );
    case 'italic':
      return TextStyle(
        color: (colour != null) ? colour : Colors.white,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.normal,
        fontSize: (size != null) ? size : defaultSize,
      );
    case 'boldItalic':
      return TextStyle(
        color: (colour != null) ? colour : Colors.white,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontSize: (size != null) ? size : defaultSize,
      );
    default:
      return TextStyle(
        color: (colour != null) ? colour : Colors.white,
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
                style: cxTextStyle(style: 'bold', colour: colour(''), size: 16),
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
              : cxTextStyle(colour: colour(''), size: 16)),
      foregroundColor: (foreground != null) ? foreground : colour(''),
      backgroundColor: (background != null) ? background : colour('sel'),
    );
  }
}

void debugToast(context) {
  disguisedToast(context: context, message: "TEST");
}

Flushbar disguisedToast(
    {required BuildContext context,
    bool? dismissible,
    String? title,
    TextStyle? titleStyle,
    required String message,
    TextStyle? messageStyle,
    Color? msgColor,
    double? msgSize,
    Color? bgcolour,
    int? secDur,
    VoidCallback? atEnd,
    String? buttonName,
    Color? buttonColour,
    TextStyle? buttonTextStyle,
    Function()? callback,
    Function()? onDismiss}) {
  return Flushbar(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(15),
    borderRadius: BorderRadius.all(Radius.circular(12)),
    backgroundColor: (bgcolour != null) ? bgcolour : Colors.black87,
    mainButton: (callback != null)
        ? TextButton(
            child: Text(
              (buttonName != null) ? buttonName : 'BUTTON',
              style:
                  (buttonTextStyle != null) ? buttonTextStyle : cxTextStyle(),
            ),
            style: ButtonStyle(
                backgroundColor: (buttonColour != null)
                    ? MaterialStateProperty.all<Color>(buttonColour)
                    : MaterialStateProperty.all<Color>(Colors.grey)),
            onPressed: () => callback(),
          )
        : null,
    duration: (secDur == null)
        ? Duration(seconds: 3)
        : (secDur == 0)
            ? null
            : Duration(seconds: secDur),
    isDismissible: (dismissible != null) ? dismissible : true,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    forwardAnimationCurve: Curves.fastOutSlowIn,
    onStatusChanged: (status) async {
      if ((status == FlushbarStatus.DISMISSED) && (onDismiss != null)) {
        onDismiss();
      }
    },
    titleText: (title != null)
        ? Text(
            title,
            style: (titleStyle != null)
                ? titleStyle
                : cxTextStyle(style: 'normal'),
          )
        : null,
    messageText: Text(
      message,
      style:
          (messageStyle != null) ? messageStyle : cxTextStyle(style: 'normal'),
    ),
  )..show(context);
}

Flushbar disguisedPrompt(
    {required BuildContext context,
    bool? dismissible,
    String? title,
    TextStyle? titleStyle,
    required String message,
    TextStyle? messageStyle,
    Color? bgcolour,
    int? secDur,
    VoidCallback? atEnd,
    String? button1Name,
    Color? button1Colour,
    Color? button1TextColour,
    String? button2Name,
    Color? button2Colour,
    Color? button2TextColour,
    Function()? button1Callback,
    Function()? button2Callback,
    Function()? onDismiss}) {
  late Flushbar flushbar;
  return flushbar = Flushbar(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(15),
    borderRadius: BorderRadius.all(Radius.circular(12)),
    backgroundColor: (bgcolour != null) ? bgcolour : Colors.black87,
    mainButton: Row(
      children: [
        TextButton(
            onPressed: (button1Callback != null)
                ? () async {
                    flushbar.dismiss(true);
                    button1Callback();
                  }
                : null,
            child: Text(
              (button1Name != null) ? button1Name : 'BUTTON',
              style: cxTextStyle(colour: button1TextColour),
            ),
            style: ButtonStyle(
                backgroundColor: (button1Colour != null)
                    ? MaterialStateProperty.all<Color>(button1Colour)
                    : MaterialStateProperty.all<Color>(Colors.grey))),
        vfill(12),
        TextButton(
            onPressed:
                (button2Callback != null) ? () => button2Callback() : null,
            child: Text(
              (button2Name != null) ? button2Name : 'BUTTON',
              style: cxTextStyle(colour: button2TextColour),
            ),
            style: ButtonStyle(
                backgroundColor: (button2Colour != null)
                    ? MaterialStateProperty.all<Color>(button2Colour)
                    : MaterialStateProperty.all<Color>(Colors.grey))),
      ],
    ),
    duration: (secDur == null)
        ? Duration(seconds: 3)
        : (secDur == 0)
            ? null
            : Duration(seconds: secDur),
    isDismissible: (dismissible != null) ? dismissible : true,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    forwardAnimationCurve: Curves.fastOutSlowIn,
    onStatusChanged: (status) async {
      if ((status == FlushbarStatus.DISMISSED) && (onDismiss != null)) {
        onDismiss();
      }
    },
    titleText: (title != null)
        ? Text(
            title,
            style: (titleStyle != null)
                ? titleStyle
                : cxTextStyle(style: 'normal'),
          )
        : null,
    messageText: Text(
      message,
      style:
          (messageStyle != null) ? messageStyle : cxTextStyle(style: 'normal'),
    ),
  )..show(context);
}
// BUILD A CLASS WITH DISGUISED TOAST AND METHODS COMBINED AND VARIABLE ASPECTS CUSTOMIZABLE

/*
double rng(double min, double max) {
  final rng = new Random();
  final double rex = max - min;
  return min + rng.nextInt(rex);
}*/

int rng(int? min, int max) {
  final rng = new Random();
  if (min == null) {
    min = 0;
  }
  final int rex = max - min;
  return min + rng.nextInt(rex);
}

/* bool checkPassword(String plainPassword) {
  return new DBCrypt().checkpw(plainPassword,
      "\$2b\$10\$/N6h1FyS267XiEoDS7bUzeIvmtI.N0GHg5KWP..cOidccJNvR0W6u");
}

String encryptPassword(String password) {
  return new DBCrypt().hashpw(password, new DBCrypt().gensalt());
}

void cryptoEncryptPassword(String password) {
  var key = utf8.encode('p@ssw0rd');
  var bytes = utf8.encode("foobar");

  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  var digest = hmacSha256.convert(bytes);

  print("HMAC digest as bytes: ${digest.bytes}");
  print("HMAC digest as hex string: $digest");

/*var cipher = crypto.createCipher(algorithm, key);  
var encrypted = cipher.update(text, 'utf8', 'hex') + cipher.final('hex');
var decipher = crypto.createDecipher(algorithm, key);
var decrypted = decipher.update(encrypted, 'hex', 'utf8') + decipher.final('utf8');*/
}*/

/*encrypt_test(String data) {
  //final data = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
  final key = encrypt.Key.fromUtf8('iQKAIzLzObCn522aw92EQB9EZECKAITC');
  final iv = encrypt.IV.fromLength(16);

  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  final encrypted = encrypter.encrypt(data, iv: iv);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);

  print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
  print(encrypted.base64);
}*/

/*class EncrypData implements IEncrypData {
  late String Key=new Buffer(key,'hex';


  @override
  String crypteFile(String data) {
    final encrypter = Encrypter(AES(key, padding: null));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  @override
  String decryptFile(String data) {
    final encrypter = Encrypter(AES(key, padding: null));
    final decrypted = encrypter.decrypt(Encrypted.from64(data), iv: iv);
    return decrypted;
  }
}*/

/*  THIS DELAY ISN'T WORKING AS A METHOD BUT WORKS IF PUT IN CODE AS IT, NO PASS
void delay(int dur) async {
  await Future.delayed(Duration(seconds: dur), () {});
}*/

/* void _select(String choice) {
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
