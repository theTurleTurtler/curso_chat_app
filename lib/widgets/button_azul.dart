import 'package:flutter/material.dart';

class ButtonAzul extends StatelessWidget {

  Function callback;
  String placeholder;

  ButtonAzul({
    Key key,
    @required this.callback,
    @required this.placeholder
  });
  

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      child: Container(
        width: double.infinity,
        child: Center(
          child: Text(
            placeholder,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17
            ),
          ),
        ),
      ),
      onPressed: callback,
    );
  }
}