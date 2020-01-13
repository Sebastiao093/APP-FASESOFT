import 'package:flutter/material.dart';

class PantallaInicial extends StatelessWidget {
  static const routedname = "/PantallaInicial";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla Inicial'),),
    body: Text('Cuerpo'),);
  }
}