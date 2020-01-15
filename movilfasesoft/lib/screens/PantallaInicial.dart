import 'package:flutter/material.dart';
import 'package:movilfasesoft/providers/azure_login_provider.dart';
import 'package:movilfasesoft/widgets/widgetSplash.dart';
import 'logedIn.dart';
import 'package:connectivity/connectivity.dart';


checkConection()async{
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi ){
    return true;
  } else {
  return false;
  }
}

class PantallaInicial extends StatelessWidget {
  static const routedname = "/PantallaInicial";
  @override
  Widget build(BuildContext context) {

  final conectado=checkConection();
    if(true){

      return  Center(
          child:FutureBuilder(
              future: UserLogin().azureLogin(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState!=ConnectionState.done) {
                  return splashScreen();
                }else{
                if(UserLogin().isloged()){
                  
                  return Logedin(snapshot.data);
                  
                }else{
                  return PantallaInicial();
                }
                }
              }),
        );
      
    }else{
      return AlertDialog(
        title: Text('Revise su conexion a internet'),
        actions: <Widget>[
          FlatButton(
            child: Text('reintentar'),
            onPressed: (){Navigator.pushReplacementNamed(context, '/');},
          )
        ],
      );

   }
  }
}
