import 'package:flutter/material.dart';
import 'package:movilfasesoft/main.dart';
import 'package:movilfasesoft/models/usuario.dart';
import 'package:movilfasesoft/providers/photoProvider.dart';
import 'package:movilfasesoft/providers/usuario_providers.dart';

class PerfilPantalla extends StatelessWidget {
  static const routedname = "/PantallaPerfil";
  String correo;
  final appBar= AppBar(
          title: Text('Perfil'),
          centerTitle: true,
          actions: <Widget>[
            Container(
                child: ImageIcon(
              AssetImage('assets/icons/fasesoftLogo.png'),
              size: 100.0,
            ))
          ],
        );

  @override
  Widget build(BuildContext context) {
    String usuarioCorreo = ModalRoute.of(context).settings.arguments as String;
    
    return Container(
      child: _infoUsuario(context, usuarioCorreo),
    );
  }

  Widget _infoUsuario(BuildContext context, String correo) {
    
    return Scaffold(
        appBar: appBar,
        body: FutureBuilder(
          future: cargarUsuario(correo),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return _detalleUsuario(snapshot.data,context);
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

  Widget _detalleUsuario(UsuarioAres user,BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constrains) {
        return Container(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: constrains.maxWidth * 0.1,
                vertical: (constrains.maxHeight-appBar.preferredSize.height-MediaQuery.of(context).padding.top) * 0.01),
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return _detalles(user);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _detalles(UsuarioAres user) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.blue,
      ),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 45.0,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userPhoto(MyApp.correoUsuario),
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
