import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/entities/user.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class UsuariosPage extends StatefulWidget {
  
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final UsersService usersService = UsersService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<User> users = [];

  @override
  void initState() { 
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: _createAppbar(context, authService.user.name),
      body: SmartRefresher(
        controller: _refreshController,
        child: _createUsuariosListView(),
        header: WaterDropHeader(
          complete: Icon(
            Icons.check, 
            color: Colors.blue[400],
          ),
          waterDropColor: Colors.blue[400],
        ),
        enablePullDown: true,
        onRefresh: _loadUsers,
      ),
    );
  }

  ListView _createUsuariosListView() {
    return ListView.separated(
      itemBuilder: (_, i)=>_createUserTile(users[i]), 
      separatorBuilder: (_, i)=>Divider(), 
      itemCount: users.length
    );
  }

  ListTile _createUserTile(User user) {
    return ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          child: Text(user.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: (){
          final ChatService chatService = Provider.of<ChatService>(context, listen: false);
          chatService.destinationUser = user;
          Navigator.of(context).pushNamed('chat');
        },
      );
  }

  Widget _createAppbar(BuildContext context, String userName){
    final SocketService socketService = Provider.of<SocketService>(context);
    return AppBar(
      title: Text(
        userName,
        style: TextStyle(
          color: Colors.black54
        ),
      ),
      elevation: 1,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.exit_to_app),
        color: Colors.black87,
        onPressed: (){
          socketService.disconnect();
          AuthService.deleteToken();
          Navigator.of(context).pushReplacementNamed('login');
        },
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: (socketService.serverStatus == ServerStatus.Online)?
            Icon( Icons.check_circle, color: Colors.blue[400] )
            : Icon(Icons.offline_bolt, color: Colors.red)
        )
      ],
    );
  }

  Future<void> _loadUsers()async{
    this.users = await usersService.loadUsers();
    //await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
    setState(() {
      
    });
  }
}