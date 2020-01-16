import 'package:flutter/material.dart';
import 'package:movilfasesoft/providers/azure_login_provider.dart';
import 'package:movilfasesoft/widgets/firstScreenWidget.dart';
import 'package:movilfasesoft/widgets/widgetSplash.dart';
import 'logedIn.dart';



class PantallaInicial extends StatelessWidget {
  static const routedname = "/PantallaInicial";
  @override
  Widget build(BuildContext context) {
    return  firstScreen(context);
    
  }

}

class LoginPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return  Center(
         child:FutureBuilder(
           future: UserLogin().azureLogin(context),
           builder: (context,snapshot){
            
             if(ConnectionState.done!=snapshot.connectionState){
               return splashScreen();
             }else{
               
               print(snapshot.data);
               if(UserLogin().isloged()){
                 return Logedin(snapshot.data);
                 }
               if(snapshot.data=='error'){
                 return Scaffold(body: Center(child: Text('error check your conection'),),
                 floatingActionButton: FloatingActionButton(child: Icon(Icons.ac_unit),backgroundColor: Colors.red,onPressed: (){Navigator.pushNamed(context,'/login');},),);
               }else{
                 return LoginPage();
               }
             }
           },

         )
            
      );
    
  }

}