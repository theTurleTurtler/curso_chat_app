import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/usuarios_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class LoadingPage extends StatelessWidget {
  BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: FutureBuilder(
        future: _checkLoginState(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Center(
            child: Text(
              'Autenticando...'
            ),
          );
        },
      ),
    );
  }

  Future<void> _checkLoginState()async{
    final SocketService socketService = Provider.of<SocketService>(_context, listen: false);
    final AuthService authService = Provider.of(_context, listen: false);
    final Map<String, dynamic> renovTokenResponse = await authService.renovarToken();
    if(renovTokenResponse['ok']){
      socketService.connect();
      _navigateToPage(UsuariosPage());
    }else{
      _navigateToPage(LoginPage());
    }
  }

  void _navigateToPage(Widget page){
    //hago la navegación de este modo para que no me aparezca efecto de navegación.
    Navigator.of(_context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___)=>page,
          transitionDuration: Duration(milliseconds: 0)
        )
      );
  }
}