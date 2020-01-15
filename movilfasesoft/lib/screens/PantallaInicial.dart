import 'package:flutter/material.dart';
import 'package:movilfasesoft/providers/azure_login_provider.dart';
import 'package:movilfasesoft/widgets/widgetSplash.dart';
import 'logedIn.dart';



class PantallaInicial extends StatelessWidget {
  static const routedname = "/PantallaInicial";
  @override
  Widget build(BuildContext context) {


      return  Center(
          child:FutureBuilder(
              future: UserLogin().azureLogin(context),
              builder: (context, snapshot) {
                // if(snapshot.data=='error'){
                  
                //     return Stack(
                //       children: <Widget>[
                //          Text('Revise su conexion a internet'),
                //           FlatButton(
                //             child: Text('reintentar'),
                //             onPressed: (){Navigator.pushReplacementNamed(context, '/');},
                //           )
                //         ],
                //       );
                  
                // }else{
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
      
  //   }else{
      // return AlertDialog(
      //   title: Text('Revise su conexion a internet'),
      //   actions: <Widget>[
      //     FlatButton(
      //       child: Text('reintentar'),
      //       onPressed: (){Navigator.pushReplacementNamed(context, '/');},
      //     )
      //   ],
      // );

  //  }
  }
}
