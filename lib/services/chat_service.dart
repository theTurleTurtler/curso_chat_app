import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/entities/user.dart';
import 'package:chat_app/models/services_responses/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier{
  User destinationUser;

  Future<List<Message>> getChat(String destinationUserId)async{
    try{
      final resp = await http.get(
        '${Environment.apiUrl}/messages/$destinationUserId',
        headers: {
          'Content-Type':'application/json',
          'Authorization': await AuthService.getToken()
        }
      );
      final messagesResponse = messagesResponseFromJson(resp.body);
      return messagesResponse.messages;
    }catch(err){
      print('Ocurrió un error:');
      print(err);
    }

  }
}