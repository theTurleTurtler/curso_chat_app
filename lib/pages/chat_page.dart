import 'dart:io';
import 'package:chat_app/models/entities/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessage> _chatMessages = [];
  SocketService _socketService;
  AuthService _authService;
  ChatService _chatService;
  User _destinationUser;
  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    //¿Por qué acá sí podemos usar el context?, ¿no importa si tenemos el listen:false?
    _chatService = Provider.of<ChatService>(context, listen: false);
    _socketService = Provider.of<SocketService>(context, listen: false);
    _authService = Provider.of<AuthService>(context, listen: false);
    _socketService.socket.on('send_private_message', _listenInnerMessage);
  }

  void _listenInnerMessage(dynamic payload){
    final ChatMessage newMessage = ChatMessage(
      texto: payload['message'], 
      uid: payload['from'], 
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300)
      )
    );
    setState(() {
      _chatMessages.insert(0, newMessage);
    });
    newMessage.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    _destinationUser = _chatService.destinationUser;
    return Scaffold(
      appBar: _createAppBar(),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i)=>_chatMessages[i],
                reverse: true,
                itemCount: _chatMessages.length,
              )
            ),
            Divider(height: 1),
            Container(
              //TODO: Caja de texto
              color: Colors.white,
              child: _createInputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _createAppBar(){
    return AppBar(
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            child: Text(
              _destinationUser.name.substring(0,2),
              style: TextStyle(
                fontSize: 12
              ),
            ),
            backgroundColor: Colors.blue[100],
            maxRadius: 15,
          ),
          SizedBox(height: 3),
          Text(
            _destinationUser.name,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12
            ),
          )
        ],
      ),
    );
  }

  Widget _createInputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String newValue){
                  //TODO: Implementar condicional de cuando hay un valor, para poder postear
                  setState(() {
                    if(newValue.trim().length > 0)
                      _estaEscribiendo = true;
                    else
                      _estaEscribiendo = false;
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: (
                Platform.isIOS?
                  CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: (
                      _estaEscribiendo?
                        ()=>_handleSubmit(_textController.text.trim())
                        : null
                    ),
                  )
                  : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(
                          Icons.send,
                        ),
                        onPressed: (
                          _estaEscribiendo?
                            ()=>_handleSubmit(_textController.text.trim())
                            : null
                        )
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmit(String text){
    if(text.length == 0)
      return;
    _textController.clear();
    _focusNode.requestFocus();

    final ChatMessage newMessage = ChatMessage(
      uid: '123', 
      texto: text, 
      animationController: 
      AnimationController(vsync: this, duration: Duration(milliseconds: 350))
    );
    _chatMessages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo = false;
    });
    _socketService.emit('send_private_message', {
      'from':_authService.user.uid,
      'for':_chatService.destinationUser.uid,
      'message':text
    });
  }

  @override
  void dispose() {
    //TODO: off del socket
    _socketService.socket.off('send_private_message');
    _socketService.dispose();
    for(ChatMessage message in _chatMessages)
      message.animationController.dispose();
    super.dispose();
  }
}