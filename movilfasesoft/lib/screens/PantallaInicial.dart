import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:movilfasesoft/providers/azure_login_provider.dart';
import 'package:movilfasesoft/widgets/NoConectionScreen.dart';
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
            print('hola: ');
            print(snapshot.data);
          
             if(snapshot.connectionState!=ConnectionState.done){
               print(snapshot.connectionState);
               return splashScreen(context);
             }
             
                if(UserLogin().isloged()&& snapshot.data!='error'&& snapshot.data!='NR'&& snapshot.data!='NA'&&snapshot.hasData){
                 
                 SchedulerBinding.instance.addPostFrameCallback((_) {
                           Navigator.pushReplacementNamed(context,'/loged');
                        });
                 return  Container();
                 }
                 if(snapshot.data=='NA'){
                   //if(UserLogin().isloged()){UserLogin().logOut(context);}
                  
                 return noConectionScreen(context,'El usuario no esta afiliado a Fasesoft'); 
                  
                 }
                 if(snapshot.data=='NR'){
                   
                 return noConectionScreen(context,'El usuario no se encuentra\n      en la base de datos'); 
                 }
               if(snapshot.data=='error'){
                
                 return noConectionScreen(context,'Error en la conexión'); 
  
                 }else{
                   try{
                     return LoginPage();
                   }catch(e){
                      return splashScreen(context);
                   }

                 }
                 
             
                 //return PantallaInicial();
                 
           
             
           },

         )
            
      );
    
  }
 
}
