import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/services_responses/users_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/models/entities/user.dart';

class UsersService{

  Future<List<User>> loadUsers()async{
    try{
      final String token = await AuthService.getToken();
      final http.Response response = await http.get(
        '${Environment.apiUrl}/users',
        headers: {
          'Content-type':'application/json',
          'Authorization': token
        }
      );
      final UsersResponse usersResponse = usersResponseFromJson(response.body);
      return usersResponse.users;
    }catch(err){
      return [];
    }
  }
}