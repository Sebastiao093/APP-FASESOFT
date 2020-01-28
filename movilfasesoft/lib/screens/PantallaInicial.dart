import 'package:flutter/material.dart';
import 'package:movilfasesoft/providers/azure_login_provider.dart';
import 'package:movilfasesoft/widgets/NoConectionScreen.dart';
import 'package:movilfasesoft/widgets/firstScreenWidget.dart';
import 'package:movilfasesoft/widgets/widgetSplash.dart';


class PantallaInicial extends StatelessWidget {
  static const routedname = "/PantallaInicial";
  @override
  Widget build(BuildContext context) {
  
    return firstScreen(context);
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    login(context);
    return splashScreen(context);
  }
}
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


login(context) async {
  var result = await UserLogin().azureLogin(context);
  if (UserLogin().isloged() &&
      result != 'error' &&
      result != 'NR' &&
      result != 'NA' &&
      result!=null) {
      Navigator.pushReplacementNamed(context, '/loged');
  }
  if (result == 'NA') {
   Navigator.pushReplacementNamed(context, '/noAfiliado');
  }
  if (result == 'NR') {
   Navigator.pushReplacementNamed(context, '/noRegistrado');
   }
  if (result == 'error') {
   Navigator.pushReplacementNamed(context, '/noConexion');
  }
}
