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
      child: _infoUsuario(context, usuarioCorreo),
    );
  }

  Widget _infoUsuario(BuildContext context, String correo) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Perfil'),
          centerTitle: true,
          actions: <Widget>[
            Container(
                child: ImageIcon(
              AssetImage('assets/icons/fasesoftLogo.png'),
              size: 100.0,
            ))
          ],
        ),
        body: FutureBuilder(
          future: cargarUsuario(correo),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return _detalleUsuario(snapshot.data);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Future<UsuarioAres> cargarUsuario(String correo) async {
    final provider = UserProvider();

    UsuarioAres usuario = await provider.getUser(correo);

    return usuario;
  }

  Widget _detalleUsuario(UsuarioAres user) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: 
        ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
          return _detalles(user);
         },
        ),
       
      ),
    );
  }


Widget _detalles(UsuarioAres user){

  return   Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.blue,
          ),
          
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 45.0,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                
                      ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  ),
                  ListTile(
                    title: Text('Nombre:'),
                    subtitle: Text(user.nombre + ' ' + user.apellido),
                  ),
                  Divider(color: Colors.blue),
                  ListTile(
                    title: Text('Identificación:'),
                    subtitle: Text(user.identificacion),
                  ),
                  Divider(color: Colors.blue),
                  ListTile(
                    title: Text('Correo:'),
                    subtitle: Text(user.correo),
                  ),
                  Divider(color: Colors.blue),
                  ListTile(
                    title: Text('Dirección:'),
                    subtitle: Text(user.direccion),
                  ),
                  Divider(color: Colors.blue),
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