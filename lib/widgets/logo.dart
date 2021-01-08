import 'package:flutter/material.dart';
/*
Lo hago como un stateless widget, en una clase aparte, porque solo se debe
renderizar una vez, para que flutter sepa cuándo renderizarlo y cuándo no
*/
class Logo extends StatelessWidget {

  final String _titulo;

  Logo({
    @required String titulo
  }):
    _titulo = titulo
    ;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:50),
      child: Column(
        children: [
          Container(
            width: 180,
            child: Image(
              image: AssetImage(
                'assets/tag-logo.png'
              ),
            ),
          ),
          Text(
            _titulo,
            style: TextStyle(
              fontSize: 30
            ),
          )
        ],
      ),
    );
  }
}