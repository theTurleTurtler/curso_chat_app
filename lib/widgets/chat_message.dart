import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ChatMessage extends StatelessWidget {

  final String texto;
  final String uid;
  final AnimationController animationController;
  AuthService _authService;

  ChatMessage({
    Key key,
    @required this.texto,
    @required this.uid,
    @required this.animationController
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    _authService = Provider.of<AuthService>(context, listen: false);
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
        child: Container(
          child: (
            this.uid == _authService.user.uid?
            _createMyMessage()
            : _createTheNotMyMessage()
          )
        ),
      ),
    );
  }

  Widget _createMyMessage(){
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
          left: 50,
          right: 5,
          top: 5
        ),
        padding: EdgeInsets.all(8),
        child: Text(
          this.texto,
          style: TextStyle(
            color: Colors.white
          ),
        ),
        decoration: BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    );
  }

  Widget _createTheNotMyMessage(){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: 5,
          right: 50,
          top: 5
        ),
        padding: EdgeInsets.all(8),
        child: Text(
          this.texto,
          style: TextStyle(
            color: Colors.black87
          ),
        ),
        decoration: BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    );
  }
}