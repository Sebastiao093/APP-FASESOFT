import 'package:flutter/material.dart';
import 'package:movilfasesoft/main.dart';
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
import 'package:movilfasesoft/utils/numberFormat.dart';

void irVotaciones(BuildContext ctx) {
  Navigator.of(ctx).pushNamed(PantallaVotaciones.routedname);
}

void irCreditos(BuildContext ctx, String user) {
  Navigator.of(ctx).pushNamed(CreditoPantalla.routedname, arguments: user);
}

void irConvenios(BuildContext ctx, String user) {
  Navigator.of(ctx).pushNamed(ConvenioPantalla.routedname, arguments: user);
}

void irQr(BuildContext ctx) {
  Navigator.of(ctx).pushNamed(PantallaQr.routedname);
}

void irPerfil(BuildContext ctx, String correo) {
  Navigator.of(ctx).pushNamed(PerfilPantalla.routedname, arguments: correo);
}

String nombre(user) {
  String resultado;
  try {
    resultado = user.nombre;
    return resultado;
  } catch (e) {
    return 'error';
  }
}

class Logedin extends StatelessWidget {
  UsuarioAres usuarioAres = new UsuarioAres();

  final String user = MyApp.correoUsuario;

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserProvider().getUser(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else {
          this.usuarioAres = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: ImageIcon(
                AssetImage('assets/icons/fasesoftLogoBarra.png'),
                size: 150.0,
              ),
              centerTitle: true,
            ),
            drawer: SafeArea(
              child: _drawer(context),
            ),
            body: _DetallesAhorro(user),
          );
        }
      },
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(nombre(this.usuarioAres)),
            accountEmail: Text(user),
            currentAccountPicture: Icon(Icons.account_circle,
            size: 80,color: Colors.white70,),
            
          ),
        
        ListTile(
          leading: Icon(Icons.person, color: Colors.blue),
          title: Text('Detalle de perfil'),
          onTap: () => irPerfil(context, user),
        ),
        ListTile(
          leading: Icon(Icons.business_center, color: Colors.blue),
          title: Text('Creditos'),
          onTap: () => irCreditos(context, user),
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
          title: Text(
            'Cerrar sesion',
            style: TextStyle(color: Colors.redAccent),
          ),
          onTap: () {
            UserLogin().logOut(context);
          },
        ),
      ],
    ));
  }

  Widget _DetallesAhorro(String correo) {
    
    FasAhorroProviders provider = FasAhorroProviders();
    return FutureBuilder(
      future: provider.getAhorroPermanente(correo),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String aporte = '';
          String monto = '';
          if (snapshot.data != null) {
            return _Ahorros(context, snapshot.data);
          }
          return ListTile(
            title: Text('acumulado ' + monto),
            subtitle: Text('aporte ' + aporte),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _Ahorros(BuildContext context, Ahorros ahorro) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blue,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 45.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                child: Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/icons/ahorroLogo.png'),
                    ),
                    Center(
                        heightFactor: 3.0, child: Text('DETALLES DE CUENTA ')),
                  
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          
                                    Divider(),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text('AHORROS')),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                '\$ ' + numberFormat(ahorro.monto.toDouble()),
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      margin: EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text('APORTE MENSUAL')),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                '\$ ' +
                                                   numberFormat(ahorro.aporte.toDouble()),
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Divider()
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              
                            ),
                          
                    
                  ],
                ),
              ),
            ),
          ),
          Container()
        ],
      ),
    );
  }
}