import 'dart:io';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessage> _chatMessages = [
   
  ];
   
  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {
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
              'TT',
              style: TextStyle(
                fontSize: 12
              ),
            ),
            backgroundColor: Colors.blue[100],
            maxRadius: 15,
          ),
          SizedBox(height: 3),
          Text(
            'The Turtle',
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
    print(text);
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
  }

  @override
  void dispose() {
    //TODO: off del socket
    for(ChatMessage message in _chatMessages)
      message.animationController.dispose();
    super.dispose();
  }
}