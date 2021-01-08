import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _crearLogo(),
          ],
        )
      )
    );
  }

  Widget _crearLogo(){
    return Center(
      child: Container(
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
              'Messenger',
              style: TextStyle(
                fontSize: 30
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
         children: [
           
         ],
       ),
    );
  }
}