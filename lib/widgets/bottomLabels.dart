import 'package:chat_app/pages/register_page.dart';
import 'package:flutter/material.dart';
class BottomLabels extends StatelessWidget {

  final String _rutaANavegar;
  final String _textLabel1;
  final String _textLabel2;

  BottomLabels({
    @required String rutaANavegar,
    @required String textLabel1,
    @required String textLabel2
  }):
    _rutaANavegar = rutaANavegar,
    _textLabel1 = textLabel1,
    _textLabel2 = textLabel2    
    ;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            _textLabel1,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15.0,
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: Text(
              _textLabel2,
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18.0,
                fontWeight: FontWeight.bold
              ),
            ),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(_rutaANavegar);
            },
          )
        ],
      )
    );
  }
}