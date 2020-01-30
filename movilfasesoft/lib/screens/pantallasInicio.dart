import 'package:flutter/material.dart';
import 'package:movilfasesoft/widgets/NoConectionScreen.dart';



class PantallaNoRegistrado extends StatelessWidget {
  static const routedname = "/noRegistrado";
  @override
  Widget build(BuildContext context) {
    return noConectionScreen(
        context, 'El usuario no se encuentra\n      en la base de datos');
  }
}
class PantallaSinConexion extends StatelessWidget {
  static const routedname = "/noConexion";
  @override
  Widget build(BuildContext context) {
   return noConectionScreen(context, 'Error en la conexión');
  }
}
class PantallaNoAfiliado extends StatelessWidget {
  static const routedname = "/noAfiliado";
  @override
  Widget build(BuildContext context) {
    return noConectionScreen(context,'El usuario no esta afiliado a Fasesoft');
  }
}
