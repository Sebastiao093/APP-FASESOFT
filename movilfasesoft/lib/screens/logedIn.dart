import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:movilfasesoft/main.dart';
import 'package:movilfasesoft/models/PerfilRol.dart';
import 'package:movilfasesoft/models/ahorro.dart';
import 'package:movilfasesoft/models/infoAsistente.dart';
import 'package:movilfasesoft/models/usuario.dart';
import 'package:movilfasesoft/models/validacionBotonVotaciones.dart';
import 'package:movilfasesoft/providers/azure_login_provider.dart';
import 'package:movilfasesoft/providers/fas_ahorro_providers.dart';
import 'package:movilfasesoft/providers/info_asistente_providers.dart';
import 'package:movilfasesoft/providers/perfilrol_provider.dart';
import 'package:movilfasesoft/providers/photoProvider.dart';
import 'package:movilfasesoft/providers/usuario_providers.dart';
import 'package:movilfasesoft/screens/AsambleaPantalla.dart';
import 'package:movilfasesoft/providers/votaciones_providers.dart';
import 'package:movilfasesoft/screens/AsistenciaQR.dart';
import 'package:movilfasesoft/screens/ConvenioPantalla.dart';
import 'package:movilfasesoft/screens/CreditoPantalla.dart';
import 'package:movilfasesoft/screens/PerfilPantalla.dart';
import 'package:movilfasesoft/screens/Votaciones.dart';
import 'package:movilfasesoft/screens/codigoQr.dart';
import 'package:movilfasesoft/utils/numberFormat.dart';
import 'package:qr_flutter/qr_flutter.dart';

void irVotaciones(BuildContext ctx, bool preguntasPorContestar) {
  Navigator.of(ctx).pushNamed(PantallaVotaciones.routedname,
      arguments: preguntasPorContestar);
}

void irAsambleas(BuildContext ctx) {
  Navigator.of(ctx).pushNamed(AsambleaPantalla.routedname);
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
  static String tipoRol;
  static Future<PerfilRol> futurePerfilRol;
  DateFormat dateConvert = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  DateFormat dateFormat = DateFormat("yyyy MMMM dd");

  Widget build(BuildContext context) {
    futurePerfilRol = cargarPerfilRol(user);
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
              body: _widget());
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
            currentAccountPicture: userPhoto(MyApp.correoUsuario)),
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
        //validacionVotacion(context),
        //validacionRol(context),
        ListTile(
          leading: Icon(Icons.supervised_user_circle, color: Colors.blue),
          title: Text('Asambleas'),
          onTap: () => irAsambleas(context),
        ),
        ListTile(
          leading: Icon(Icons.filter_center_focus, color: Colors.blue),
          title: Text('Asistencia'),
          onTap: () => irQr(context),
        ),

        ListTile(
          leading: Icon(Icons.center_focus_weak),
          title: Text(
            'Generar QR ',
            style: TextStyle(color: Colors.blueAccent),
          ),
          onTap: () {
            Navigator.of(context).pushNamed('/qr');
          },
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
        ListTile(
          leading: Icon(Icons.filter_center_focus, color: Colors.blue),
          title: Text('Asistencia'),
          onTap: () => irQr(context),
        )
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
    return ListView(
      children: <Widget>[
        Container(
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
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    child: Column(
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/icons/ahorroLogo.png'),
                          //Iconos diseñados por <a href="https://www.flaticon.es/autores/itim2101" title="itim2101">itim2101</a> from <a href="https://www.flaticon.es/" title="Flaticon"> www.flaticon.es</a>
                        ),
                        Center(
                            heightFactor: 3.0,
                            child: Text('DETALLES DE CUENTA ')),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              Divider(),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text('AHORROS')),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          '\$ ' +
                                              numberFormat(
                                                  ahorro.monto.toDouble()),
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
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
                                              numberFormat(
                                                  ahorro.aporte.toDouble()),
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Divider(),
                                    GestureDetector(
                                      child: Text(MyApp.token),
                                      onLongPress: () {
                                        Clipboard.setData(new ClipboardData(
                                            text: MyApp.token));
                                      },
                                    )
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
        )
      ],
    );
  }

  static Future<PerfilRol> cargarPerfilRol(String correo) async {
    final perfilProvider = PerfilRolProvider();
    PerfilRol perfilRol = await perfilProvider.getPerfilRol(correo);
    //tipoRol = perfilRol.tipo;
    return perfilRol;
  }

  Widget validacionRol(BuildContext ctx) {
    return FutureBuilder<PerfilRol>(
      future: futurePerfilRol,
      builder: (ctx, perfilAux) {
        if (perfilAux.hasData) {
          if (perfilAux.data.tipo == 'ASISTENCIA') {
            return ListTile(
              leading: Icon(Icons.filter_center_focus, color: Colors.blue),
              title: Text('Asistencia'),
              onTap: () => irQr(ctx),
            );
          } else {
            return Container();
          }
        } else if (perfilAux.hasError) {
          return Container();
        }
      },
    );
  }

  Widget _movimientosAportes(String correo) {
    FasAhorroProviders provider = FasAhorroProviders();

    return FutureBuilder(
      future: provider.getMovimientosAporte(correo),
      builder: (context, AsyncSnapshot<List<Ahorros>> snap) {
        if (snap.hasData) {
          return _detallesMovimientosAportes(snap.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _detallesMovimientosAportes(List<Ahorros> movimientos) {
    Widget list = ListView.builder(
      itemCount: movimientos.length,
      itemBuilder: (ctx, posicion) {
        String tipoAporte = 'Permanente';
        String sinFecha = 'Fecha: Indefinida';
        if (movimientos[posicion].fasTiposAhoIdTipoAho == 2) {
          tipoAporte = 'Voluntario';
        }

        if (movimientos[posicion].fechaInicioAporte != null) {
          try {
            DateTime fecha =
                dateConvert.parse(movimientos[posicion].fechaInicioAporte);
            sinFecha = 'Fecha: ' + dateFormat.format(fecha);
          } on FormatException {
            sinFecha = 'Fecha: ' + movimientos[posicion].fechaInicioAporte;
          }
        }

        return Column(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.monetization_on,
                  color: Colors.green,
                ),
                trailing: Text(
                    '\$ ' +
                        numberFormat(
                          movimientos[posicion].aporte.toDouble(),
                        ),
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis),
                title: Text(
                  tipoAporte,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(sinFecha, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        );
      },
    );

    return list;
  }

  Widget _widget() {
    return
        // _DetallesAhorro(user);
        _movimientosAportes(user);
  }
}

Widget validacionVotacion(BuildContext ctx) {
  return FutureBuilder<ValidacionBotonVotaciones>(
    future:
        Votaciones_providers.getValidacionBotonVotaciones(MyApp.correoUsuario),
    builder: (ctx, validacionAux) {
      if (validacionAux.hasData) {
        if (validacionAux.data.hayAsamblea == null ||
            validacionAux.data.asistio == null ||
            validacionAux.data.preguntasPorContestar == null) {
          return Container();
        }
        if (validacionAux.data.hayAsamblea &&
            validacionAux.data.asistio &&
            validacionAux.data.preguntasPorContestar) {
          return ListTile(
            leading: Icon(Icons.question_answer, color: Colors.blue),
            title: Text('Votaciones'),
            onTap: () =>
                irVotaciones(ctx, validacionAux.data.preguntasPorContestar),
          );
        } else {
          return Container();
        }
      } else if (validacionAux.hasError) {
        return Container();
      }
      return Container();
    },
  );
}
