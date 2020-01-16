import 'package:flutter/material.dart';
import 'package:movilfasesoft/models/usuario_ares.dart';
import 'package:movilfasesoft/providers/usuario_providers.dart';

class PerfilPantalla extends StatelessWidget {
  
  static const routedname = "/PantallaPerfil";
  
  

  @override
  Widget build(BuildContext context) {

    return Container(
          
      child: _infoUsuario(context),
    );
  }

Widget _infoUsuario(BuildContext context){

    
    return Scaffold(

      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: FutureBuilder(
        future: cargarUsuario(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData){
            return _detalleUsuario(snapshot.data);
          }else{
            return CircularProgressIndicator(); 

             
          }

        },

      )
    );



}

Future <UsuarioAres> cargarUsuario() async{

 final  provider=UsuarioProviders();
 UsuarioAres usuario= await provider.getUsuario('mocampo@asesoftware.com');

return usuario;

  
}


Widget _detalleUsuario(UsuarioAres user){

  return Column(
        children: <Widget>[
          
          ListTile(
            title: Text(user.nombre +' ' +user.apellido),
                       
          ),
          ListTile(
            title: Text(user.identificacion),
          ),
          ListTile(
            title: Text(user.correo),
          ),
          ListTile(
            title: Text(user.direccion),
          ),
          ListTile(
            title: Text(user.telefono),
          ),  
          
        ],

      );
}

}