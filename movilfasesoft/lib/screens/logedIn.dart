import 'package:flutter/material.dart';
import 'package:movilfasesoft/models/ahorro.dart';

import 'package:movilfasesoft/models/usuario.dart';
import 'package:movilfasesoft/providers/azure_login_provider.dart';
import 'package:movilfasesoft/providers/fas_ahorro_providers.dart';
import 'package:movilfasesoft/providers/usuario_providers.dart';
import 'package:movilfasesoft/screens/AsistenciaQR.dart';
import 'package:movilfasesoft/screens/ConvenioPantalla.dart';
import 'package:movilfasesoft/screens/CreditoPantalla.dart';
import 'package:movilfasesoft/screens/PerfilPantalla.dart';
import 'package:movilfasesoft/screens/Votaciones.dart';



void irVotaciones(BuildContext ctx) {
  Navigator.of(ctx).pushNamed(PantallaVotaciones.routedname);
}

void irCreditos(BuildContext ctx,String user) {
  Navigator.of(ctx).pushNamed(CreditoPantalla.routedname,arguments: user);
}


void irConvenios(BuildContext ctx, String user) {
  Navigator.of(ctx).pushNamed(ConvenioPantalla.routedname, arguments: user);
}

void irQr(BuildContext ctx) {
  Navigator.of(ctx).pushNamed(PantallaQr.routedname);
}

void irPerfil(BuildContext ctx,String correo){
  Navigator.of(ctx).pushNamed(PerfilPantalla.routedname,arguments: correo);
}


String nombre(user){
  String resultado;
  try{
    resultado=user.nombre;
    return resultado;
  }catch(e){
    return 'error';
  }

}

class Logedin extends StatelessWidget {

UsuarioAres usuarioAres = new UsuarioAres();
String user='';
Logedin(user){
  this.user= user as String;
}
 

  Widget build(BuildContext context){
   
    return FutureBuilder(
      future: UserProvider().getUser(user),
      builder: (context,snapshot){
        if(snapshot.connectionState!=ConnectionState.done){
          return CircularProgressIndicator();
        }else{
          this.usuarioAres=snapshot.data;
          return Scaffold(
          appBar:AppBar(title: Text('Fasesoft Mobile'),) ,
          drawer: SafeArea(
          child:Drawer(
           child: ListView(
           children: <Widget>[
            UserAccountsDrawerHeader(
              accountName:  Text(nombre(this.usuarioAres)),
              accountEmail: Text(user),
              currentAccountPicture: Icon(Icons.account_circle),
            ),
          
           ListTile(
             leading: Icon(Icons.person,  color: Colors.blue),
             title: Text('Detalle de cuenta'),
             onTap: () => irPerfil(context,user),             
           ),

           ListTile(
            leading: Icon(Icons.business_center, color: Colors.blue),
            title: Text('Creditos'),
            onTap: () => irCreditos(context,user),
          ),

          ListTile(
            leading: Icon(Icons.storage, color: Colors.blue),
            title: Text('Convenios'),
            onTap: () => irConvenios(context, user),
          ),

          ListTile(
            leading: Icon(Icons.question_answer, color: Colors.blue),
            title: Text('Votaciones'),
            onTap: () => irVotaciones(context),
          ),

          ListTile(
            leading: Icon(Icons.filter_center_focus, color: Colors.blue),
            title: Text('Asistencia'),
            onTap: () => irQr(context),
          ),
           ListTile(
             leading: Icon(Icons.close),
             title: Text('Cerrar sesion',style: TextStyle(color: Colors.redAccent),),
             onTap: (){ UserLogin().logOut(context); } ,
                          
           ),
           _DetallesAhorro(user)

           
            
           ],
          
           )

         ),
         ),
          body: GridView.count(
  primary: false,
  padding: const EdgeInsets.all(20),
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  crossAxisCount: 2,
  children: <Widget>[
           RaisedButton(
            child: Text('Votaciones'),
            onPressed: () => irVotaciones(context),
          
          ),
          RaisedButton(
            child: Text('Credito'),
            onPressed: ()=>irCreditos(context,user),
          ),
          RaisedButton(
            child: Text('Convenios'),
            onPressed: () => irConvenios(context, user),
          ),
          RaisedButton(
            child: Text('QR'),
            onPressed: () => irQr(context),
          ),
          RaisedButton(
            child: Text('Perfil'),
            onPressed: () => irPerfil(context,user),
          ),

  ],
)
          
      
        );
        }
      },
    );


  }


 Widget _DetallesAhorro(String correo)  {
 FasAhorroProviders provider=FasAhorroProviders();

   return 
   
   FutureBuilder(
            future: provider.getAhorroPermanente(correo),
            builder: (context,snapshot){
              if(snapshot.hasData){
                 String aporte='pailas';
                  String monto='no hay lucas';
                  if(snapshot.data!=null){    
                      Ahorros ahorro=snapshot.data;
                      aporte=ahorro.aporte.toString();
                      monto=ahorro.monto.toString();

                  }

                  return ListTile(
                    title: Text('acumulado '+monto),
                    subtitle: Text('aporte '+aporte),
                  );

              }else{

                return CircularProgressIndicator(backgroundColor:  Colors.red,);
              }

            },

   );
     
      }

  
}