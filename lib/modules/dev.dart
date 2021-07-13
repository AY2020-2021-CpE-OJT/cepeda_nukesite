import 'package:flutter/material.dart';

Color color(String id) {
  switch (id) {
    case ('black'):
      return Colors.black;
    case ('blue'):
      return Colors.blue;
    case ('lblue'):
      return Colors.lightBlue;
    case ('dblue'):
      return Color(0xFF00005E);
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
    default:
      print('colorNot Identifed');
      return Colors.white;
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
      labelStyle: idTextStyle('bold', selectedColor, 15),
      //errorText: (ctrlrID.text.isEmpty) ? "Field is Required" : null,
    ),
    style: idTextStyle('bold', defaultColor, 15),
  );
}

Widget cText(String text, Color? colour, double? size, String? style) {
  return Text(text, style: idTextStyle(style, colour, size));
}

TextStyle idTextStyle(String? style, Color? colour, double? size) {
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

  Widget hfill(double height) {
    return SizedBox(height: height);
  }