import 'package:flutter/material.dart';

import 'package:movilfasesoft/models/usuario.dart';
import 'package:movilfasesoft/providers/azure_login_provider.dart';
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
             leading: Icon(Icons.center_focus_weak),
             title: Text('Qr de asistencia'),
             onTap: (){Navigator.pushReplacementNamed(context,'/qr',arguments: user);} ,             
           ),
           ListTile(
             leading: Icon(Icons.person),
             title: Text('Detalle de cuenta'),
             onTap: (){Navigator.pushReplacementNamed(context,'/detail',arguments: user);} ,             
           ),
           ListTile(
             leading: Icon(Icons.close),
             title: Text('Cerrar sesion',style: TextStyle(color: Colors.redAccent),),
             onTap: (){ UserLogin().logOut(context); } ,
                          
           ),
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
}