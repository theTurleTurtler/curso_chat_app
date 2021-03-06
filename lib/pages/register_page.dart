import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/bottomLabels.dart';
import 'package:chat_app/widgets/button_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/helpers/show_alert.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            height: screenHeight * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(titulo: 'Registro'),
                _Form(),
                BottomLabels(
                  rutaANavegar: 'login',
                  textLabel1: 'Ya tienes una cuenta?',
                  textLabel2: 'Entra ahora!',
                ),
                _createBottomText()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createBottomText(){
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        'Términos de condiciones y uso',
        style: TextStyle(
          fontWeight: FontWeight.w300
        ),
      )
    );
  }
}



class _Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthService authService;
  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthService>(context);
    final SocketService socketService = Provider.of<SocketService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(
        horizontal: 50
      ),

      child: Column(
        children: [
          CustomInput(
            icon: Icons.account_circle,
            hintText: 'Nombre',
            keyboardType: TextInputType.emailAddress,
            textController: _nameController,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            hintText: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: _emailController,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            hintText: 'Contraseña',
            textController: _passwordController,
            isPassword: true,
          ),
          //TODO: crear botón
          ButtonAzul(
            placeholder: 'Ingresar',
            callback: authService.autenticando? null : ()async{
              FocusScope.of(context).unfocus();
              final Map<String, dynamic> servResponse = await authService.register(
                _nameController.text, 
                _emailController.text, 
                _passwordController.text
              );
              if(servResponse['ok']){
                socketService.connect();
                Navigator.of(context).pushReplacementNamed('usuarios');
              }else{
                mostrarAlerta(context, 'Register fallido', '${servResponse['msg']}');
              }
            },
          )
        ],
      ),
    );
  }

  Future<void> _register(){

  }
}