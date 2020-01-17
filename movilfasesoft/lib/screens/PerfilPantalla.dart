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
 
   return Container(
   
     child: Center(
       child: Card(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(15.0)
         ),
          elevation: 15.0,
           
       
       child: Column(
         mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: MainAxisAlignment.center,
        
         children: <Widget>[
           ListTile(
             leading: Icon(Icons.person),
           ),
             ListTile(
               
               title: Text('Nombre:'),
               subtitle: Text(user.nombre +' ' +user.apellido),
                          
             ),
             ListTile(
               
               title: Text('Identificación:'),
               subtitle: Text(user.identificacion),
             ),
             ListTile(
               title: Text('Correo:'),
               subtitle: Text(user.correo),
             ),
             ListTile(
               title: Text('Dirección:'),
               subtitle: Text(user.direccion),
             ),
             ListTile(
               title: Text('Teléfono:'),
               subtitle: Text(user.telefono),
             ), 
         ],
       ),
       ),
      
     ),
   );
     
    
 }
 
 }
 
