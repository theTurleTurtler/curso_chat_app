import 'dart:convert';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
class AuthService with ChangeNotifier{
  final FlutterSecureStorage _storage = new FlutterSecureStorage();
  User user;
  bool _autenticando = false;
  
  bool get autenticando => this._autenticando;
  set autenticando (bool valor){
    this._autenticando = valor;
    notifyListeners();
  }

  /*
    En caso de que en otro lugar de la app queramos llamar, o borrar, el token sin necesidad de instancair el AuthService
  */
  static Future<String> getToken() async{
    final FlutterSecureStorage storageImpl = FlutterSecureStorage();
    final String token = await storageImpl.read(key: 'token');
    return token;
  }

  static Future deleteToken() async{
    final FlutterSecureStorage storageImpl = FlutterSecureStorage();
    await storageImpl.delete(key: 'token');
  }

  Future<bool> login(String email, String password)async{
    try{
      this.autenticando = true;
      final Map<String, dynamic> data = {
        'email':email,
        'password':password
      };
      final http.Response resp = await http.post(
        '${Environment.apiUrl}/login',
        headers: {'Content-Type':'application/json'},
        body: jsonEncode(data)
      );
      if(resp.statusCode == 200){
        final LoginResponse loginResponse = loginResponseFromJson(resp.body);
        this.user = loginResponse.user;
        await _saveToken(loginResponse.token);
      }else{
        return false;
      }
      print(resp.body);
      return true;
    }catch(err){
      print(err);
      return false;
    }finally{
      this.autenticando = false;
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password)async{
    try{
      this.autenticando = true;
      final Map<String, dynamic> data = {
        'name':name.trim(),
        'email':email.trim(),
        'password':password.trim(),
        'password_confirmation':password.trim()
      };
      final http.Response resp = await http.post(
        '${Environment.apiUrl}/login/new',
        headers: {'Content-Type':'application/json'},
        body: jsonEncode(data)
      );
      if(resp.statusCode == 200){
        final LoginResponse loginResponse = loginResponseFromJson(resp.body);
        this.user = loginResponse.user;
        await _saveToken(loginResponse.token);
      }else{
        print('respuesta mala');
        print('${resp.statusCode}::${resp.body}');
      }
      final Map<String, dynamic> respBody = jsonDecode(resp.body).cast<String, dynamic>();
      return respBody;
    }on Error catch(err){
      print('Ocurrió un error');
      print(err.stackTrace);
      return {
        'ok':false,
        'message':'Pos no sabemos que ha ocurrido'
      };
    }finally{
      this.autenticando = false;
    }
  }

  Future<Map<String, dynamic>> renovarToken()async{
    try{
      final String token = await _storage.read(key: 'token');
      final http.Response resp = await http.get(
        '${Environment.apiUrl}/login/relogin',
        headers: {
          'Content-Type':'application/json',
          'Authorization':token
        },
      );
      if(resp.statusCode == 200){
        print('token todo bien, todo correcto.');
        final LoginResponse loginResponse = loginResponseFromJson(resp.body);
        this.user = loginResponse.user;
        await _saveToken(loginResponse.token);
      }else{
        print('token no todo bien, no todo correcto');
        print(resp.body);
        this._logout();
        return {
          'ok':false
        };
      }
      final Map<String, dynamic> respBody = jsonDecode(resp.body).cast<String, dynamic>();
      return respBody;
    }on Error catch(err){
      print('Ocurrió un error');
      print(err.stackTrace);
      return {
        'ok':false,
        'message':'Pos no sabemos que ha ocurrido'
      };
    }
  }

  Future _saveToken(String token)async{
    await _storage.write(key: 'token', value: token);
  }

  Future _logout()async{
    await _storage.delete(key: 'token');
  }
}