import 'package:flutter/material.dart';
import 'package:movilfasesoft/models/usuario.dart';
import 'package:movilfasesoft/providers/usuario_providers.dart';

class PerfilPantalla extends StatelessWidget {
  
  static const routedname = "/PantallaPerfil";
  String correo;
  

  @override
  Widget build(BuildContext context) {
    String usuarioCorreo = ModalRoute.of(context).settings.arguments as String; 

    return Container(
      child: _infoUsuario(context,usuarioCorreo),
    );
  }

Widget _infoUsuario(BuildContext context, String correo){

    
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: FutureBuilder(
        future: cargarUsuario(correo),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
         final data=snapshot.data;
          if (snapshot.hasData){
            return _detalleUsuario(snapshot.data);
          }else{
            return CircularProgressIndicator(); 

             
          }

        },

      )
    );



}

Future <UsuarioAres> cargarUsuario(String correo) async{

 

  final provider=UserProvider();
  
  
  UsuarioAres usuario= await provider.getUser(correo);
 
 return usuario;
 
   
 }
 
 
 Widget _detalleUsuario(UsuarioAres user){
 
   return Column(
         children: <Widget>[
           
           ListTile(
             title: Text('Nombre: ' + user.nombre +' ' +user.apellido),
                        
           ),
           ListTile(
             title: Text('Identificación: ' + user.identificacion),
           ),
           ListTile(
             title: Text('Correo: '+ user.correo),
           ),
           ListTile(
             title: Text('Dirección: '+user.direccion),
           ),
           ListTile(
             title: Text('Teléfono: '+user.telefono),
           ),  
           
         ],
 
       );
 }
 
 }
 
 class UsuarioProvider {
}