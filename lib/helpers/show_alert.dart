import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void mostrarAlerta(BuildContext context, String titulo, String subtitulo){
  if(Platform.isAndroid)
    _showAndroidDialog(context, titulo, subtitulo);
  else{
    _showIOSDialog(context, titulo, subtitulo);
  }
}

void _showAndroidDialog(BuildContext context, String titulo, String subtitulo){
  showDialog(
    context: context,
    builder: (_)=>AlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: [
        MaterialButton(
          child: Text('Ok'),
          elevation: 5,
          textColor: Colors.blue,
          onPressed: ()=>Navigator.pop(context)
        )
      ],
    )
  );
}

void _showIOSDialog(BuildContext context, String titulo, String subtitulo){
  showCupertinoDialog(
    context: context,
    builder: (_)=>CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Ok'),
          onPressed: ()=>Navigator.pop(context)
        )
      ],
    )
  );
}