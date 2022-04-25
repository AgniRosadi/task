import 'package:flutter/material.dart';

class DefaultButton {
  static Widget buttonPrimary(BuildContext context, String text, Function() onPressed){
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          primary: Theme.of(context).primaryColor,
        ),
        child: Text(
          text,
          style: const TextStyle(fontFamily: "RubrikBold", color: Colors.white, fontSize: 24),
        ));
  }

  static Widget buttonSecondary(BuildContext context, String text, Function() onPressed){
    return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            side: BorderSide(color: Theme.of(context).primaryColor)
        ),
        child: Text(
          text,
          style: TextStyle(fontFamily: "RubrikBold", color: Theme.of(context).primaryColor, fontSize: 24),
        ));
  }


  static Widget buttonAction(BuildContext context, String text, Function() onPressed){
    return OutlinedButton(
      onPressed: onPressed,
      style:
      OutlinedButton.styleFrom(primary: Colors.black, backgroundColor: Colors.white, side: const BorderSide(width: 1)),
      child: Text(text, style: const TextStyle(fontFamily: "RubrikSemiBold", color: Colors.black, fontSize: 17)),
    );
  }


  static Widget buttonActionAlt(BuildContext context, String text, Function() onPressed){
    return OutlinedButton(
      onPressed: onPressed,
      style:
      OutlinedButton.styleFrom(primary: Colors.black, backgroundColor: Theme.of(context).primaryColor, side: const BorderSide(width: 1)),
      child: Text(text, style: const TextStyle(fontFamily: "RubrikSemiBold", color: Colors.white, fontSize: 17)),
    );
  }


}