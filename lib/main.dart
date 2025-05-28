import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Prueba Web',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hola desde Flutter Web'),
        ),
        body: Center(
          child: Text(
            '¡La app se está mostrando correctamente!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
