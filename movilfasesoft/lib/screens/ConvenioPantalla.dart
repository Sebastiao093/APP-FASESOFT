import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/Convenio.dart';
import 'dart:async';
import 'dart:convert';

import 'package:movilfasesoft/models/TipoConvenio.dart';

class ConvenioPantalla extends StatefulWidget {
  static const routedname = "/PantallaConvenios";
  static var correo = "shgarcia@asesoftware.com";
  static List<TipoConvenio> elementoTipoConvenio;

  @override
  _ConvenioPantallaState createState() => _ConvenioPantallaState();
}

Future<List<dynamic>> obtenerData(String correo) async {
  String _url = '173.16.0.35:7001';
  final urlfin = Uri.http(
      _url,
      'fasesoft-web/webresources/servicios/fasconvenios/misconvenios',
      {'correo': correo});
  final response = await http.get(urlfin);

  if (response.statusCode == 200) {
    final decodedData = json.decode(response.body);

    return decodedData;
  } else {
    throw Exception('error');
  }
}

class _ConvenioPantallaState extends State<ConvenioPantalla> {
  @override
  Widget build(BuildContext context) {
    String usuarioCorreo = ModalRoute.of(context).settings.arguments as String;
    Future<List<dynamic>> userData = obtenerData(usuarioCorreo);

    return Scaffold(
      appBar: AppBar(
        title: Text('Convenios'),
      ),
      body: contenido1(userData, context),
    );
  }
}

Widget ElementosCartas(Convenio elemento, BuildContext ctx) {
  return Card(
    elevation: 10.0,
    margin: EdgeInsets.all(5.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Container(
      width: 100,
      height: 65,
      margin: EdgeInsets.all(25.0),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Column(
                  children: <Widget>[
                    traerTipoConvenio(elemento, ctx),
                  ]),
              Column(
                children: <Widget>[
                ],
              )
            ],
          ),
        ],
      ),
    ),
  );
}

Widget contenido1(Future<List<dynamic>> elementos, BuildContext ctx) {
  return Center(
    child: FutureBuilder<List<dynamic>>(
      future: elementos,
      builder: (context, auxElementos) {
        if (auxElementos.hasData) {
          
          return ListView.builder(
            itemCount: auxElementos.data.length,
            itemBuilder: (context, index) {
              var elemento = new Convenio.fromJson(
                  auxElementos.data.elementAt(index) as Map<String, dynamic>);

              return ElementosCartas(elemento, ctx);
            },
          );
        }
        else if (auxElementos.hasError) {
          return Text('${auxElementos.error}');
        }
        return CircularProgressIndicator();
      },
    ),
  );
}

Widget traerTipoConvenio(Convenio convenio, BuildContext ctx) {
  String idTipoConvenio = convenio.idtipoconvenio.toString();
  Future<List<dynamic>> idTipoData = obtenerIdConvenioData(idTipoConvenio);

  return Container(
    height: 45,
    width: 400,
    child: Center(
        child: FutureBuilder<List<dynamic>>(
      future: idTipoData,
      builder: (context, auxElementos) {
        if (auxElementos.hasData) {
          return ListView.builder(
            itemCount: auxElementos.data.length,
            itemBuilder: (context, index) {
              var elemento = new TipoConvenio.fromJson(
                  auxElementos.data.elementAt(index) as Map<String, dynamic>);
              
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(elemento.tipo),
                      Text(convenio.fechaSolicitud.substring(0, 10))
                    ],
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RaisedButton(
                          padding: EdgeInsets.all(7.0),
                          elevation: 7.0,
                          child: Text(convenio.estado),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          color: getColor(convenio.estado.toString()),
                          onPressed: () {
                            mostrarAlerta(ctx, convenio, elemento);
                          },
                        )
                      ])
                ],
              );
            },
          );
        } else if (auxElementos.hasError) {
          return Text('${auxElementos.error}');
        }
        return Text('');
      },
    )),
  );
}

Future<List<dynamic>> obtenerIdConvenioData(String idTipoConvenio) async {
  
  String _url = '173.16.0.35:7001';
  final urlfintipoconvenio = Uri.http(
      _url,
      'fasesoft-web/webresources/servicios/fastiposconvenio/test/' +
          idTipoConvenio);
  final response = await http.get(urlfintipoconvenio);

  if (response.statusCode == 200) {
    
    final decodedidTipoData = json.decode(response.body);

    return decodedidTipoData;
  } else {
    throw Exception('error');
  }
}

Color getColor(elemento) {
  if (elemento == 'REGISTRADO') {
    return Colors.blue;
  } else if (elemento == 'APROBADO') {
    return Colors.green;
  } else if (elemento == 'RECHAZADO') {
    return Colors.red;
  } else if (elemento == 'FINALIZADO') {
    return Colors.grey;
  } else if (elemento == 'CANCELADO') {
    return Colors.green[200];
  } else
    return Colors.black;
}

void mostrarAlerta(
    BuildContext ctx, Convenio elemento, TipoConvenio tipoconvenio) {
  showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
            title:
                Text((tipoconvenio.tipo), style: TextStyle(color: Colors.blue)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Fecha: ' + elemento.fechaSolicitud.substring(0, 10)),
                  ],
                ),
                Divider(color: Colors.blue),
                Container(
                  child: Column(children: <Widget>[
                    ListTile(
                      title: Text('Descripción: ' +
                          tipoconvenio.descripcion.toString()),
                      subtitle:
                          Text('Estado: ' + elemento.estado.toLowerCase()),
                    )
                  ]),
                ),
                Divider(color: Colors.blue),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Cuotas: ' + elemento.numeroCuotas.toString()),
                  ],
                )
              ],
            ));
      });
}
