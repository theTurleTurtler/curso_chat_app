import 'package:flutter/material.dart';
import 'package:chat_app/widgets/bottomLabels.dart';
import 'package:chat_app/widgets/button_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/logo.dart';
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

  @override
  Widget build(BuildContext context) {
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
            callback: (){
              print(_emailController.text);
              print(_passwordController.text);
            },
          )
        ],
      ),
    );
  }
}

