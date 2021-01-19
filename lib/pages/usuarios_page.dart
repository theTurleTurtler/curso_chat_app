import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/utils/usuarios_test.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class UsuariosPage extends StatefulWidget {
  
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: _createAppbar(authService.user.name),
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
        onRefresh: _loadUsuarios,
      ),
    );
  }

  ListView _createUsuariosListView() {
    return ListView.separated(
      itemBuilder: (_, i)=>_createUserTile(usuarios[i]), 
      separatorBuilder: (_, i)=>Divider(), 
      itemCount: usuarios.length
    );
  }

  ListTile _createUserTile(User usuario) {
    return ListTile(
        title: Text(usuario.name),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          child: Text(usuario.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }

  Widget _createAppbar(String userName){
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
          //TODO: Desconectarse del socketServer
          AuthService.deleteToken();
          Navigator.of(context).pushReplacementNamed('login');
        },
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Icon(Icons.check_circle, color: Colors.blue[400]),
          //child: Icon(Icons.offline_bolt, color: Colors.red)
        )
      ],
    );
  }

  Future<void> _loadUsuarios()async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}