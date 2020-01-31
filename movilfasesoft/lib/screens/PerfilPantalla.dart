import 'package:flutter/material.dart';
import 'package:movilfasesoft/main.dart';
import 'package:movilfasesoft/models/usuario.dart';
import 'package:movilfasesoft/providers/photoProvider.dart';
import 'package:movilfasesoft/providers/usuario_providers.dart';
import 'package:flutter/cupertino.dart';

class PerfilPantalla extends StatelessWidget {
  static const routedname = "/PantallaPerfil";
  String correo;

  final appbarIos= CupertinoNavigationBar(middle:Text('Perfil'));
  final appBarAndroid= AppBar(
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
        appBar: appBarAndroid,
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
                horizontal: constrains.maxWidth * 0.05,
                vertical: (constrains.maxHeight-appBarAndroid.preferredSize.height-MediaQuery.of(context).padding.top) * 0.01),
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
        elevation: 15.0,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
            child: CircleAvatar(
              child: userPhoto(MyApp.correoUsuario),
              backgroundColor: Colors.white,
              maxRadius: 96.0,
            ),
            backgroundColor: Colors.blue,
            maxRadius: 100.0,
          ),
              Divider(color:Colors.white10),
              _informacion('Nombre', Icons.person, user.nombre+ ' ' + user.apellido),
            
              Divider(color: Colors.blue),
              _informacion('Identificación:',Icons.fingerprint, user.identificacion),
              Divider(color: Colors.blue),
              _informacion('Correo:', Icons.mail,user.correo),
              Divider(color: Colors.blue),
              _informacion('Dirección:', Icons.home,user.direccion),
              Divider(color: Colors.blue),
              _informacion('Teléfono:', Icons.phone, user.telefono)
             
            ],
          ),
        ),
      ),
    );
  }
}

  Widget _informacion(String parametro,IconData icono,String informacion){ 
    return Row(
      children: <Widget>[
        Icon(icono,color: Colors.blue,),
        SizedBox(width: 10.0,),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(30.0),
            ),
          child:ListTile(
            title: Text(parametro),
            subtitle: Text(informacion,textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,)),
          ),
        )
      ],
    );
  }