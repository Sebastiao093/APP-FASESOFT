import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/Convenio.dart';
import 'dart:async';
import 'dart:convert';

import 'package:movilfasesoft/models/TipoConvenio.dart';

class ConvenioPantalla extends StatefulWidget {
  static const routedname = "/PantallaConvenios";
  static var correo = "shgarcia@asesoftware.com";

  @override
  _ConvenioPantallaState createState() => _ConvenioPantallaState();
}

Future<List<dynamic>> obtenerData(String correo) async {
  print(correo);
  String _url = '173.16.0.35:7001';
  final urlfin = Uri.http(
      _url,
      'fasesoft-web/webresources/servicios/fasconvenios/misconvenios',
      {'correo': correo});
  //print(urlfin);
  final response = await http.get(urlfin);

  if (response.statusCode == 200) {
    debugPrint(response.body);
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
      body: contenido1(userData),
    );
  }
}

Widget ElementosCartas(Convenio elemento) {
  return Card(
    elevation: 5.0,
    margin: EdgeInsets.all(5.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //Text(elemento.idtipoconvenio.toString()),
            Text(elemento.idConvenio.toString()),
            traerTipoConvenio(elemento.idtipoconvenio.toString())
          ],
        ),
        Text(elemento.fechaSolicitud.substring(0, 10)),
        Text(elemento.estado),
      ],
    ),
  );
}

Widget contenido1(Future<List<dynamic>> elementos) {
  return Center(
    child: FutureBuilder<List<dynamic>>(
      future: elementos,
      builder: (context, auxElementos) {
        if (auxElementos.hasData) {
          //Elemento element = new Elemento(auxElementos.data.first as Map<String,Dynamic>);
          return ListView.builder(
            itemCount: auxElementos.data.length,
            itemBuilder: (context, index) {
              var elemento = new Convenio.fromJson(
                  auxElementos.data.elementAt(index) as Map<String, dynamic>);

              return ElementosCartas(elemento);
            },
          );
        } /*else if (!auxElementos.hasData) {
          return Card(
            child: Column(
              children: <Widget>[
                Text(
                    'No tienes Convenios con nosotros, adquiere uno con nosotros')
              ],
            ),
          );
        }*/else if (auxElementos.hasError) {
          return Text('${auxElementos.error}');
        }
        return CircularProgressIndicator();
      },
    ),
  );
}

Widget traerTipoConvenio(String idTipoConvenio) {
  Future<List<dynamic>> idTipoData = obtenerIdConvenioData(idTipoConvenio);

  return Container(
    height: 200,
    width: 100,
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

              return Column(
                children: <Widget>[
                  Text(elemento.tipo),
                  Text(elemento.descripcion),
                ],
              );
            },
          );
        } else if (auxElementos.hasError) {
          return Text('${auxElementos.error}');
        }
        return null;
      },
    )),
  );
}

Widget ElementosCartas2(TipoConvenio elemento) {
  return Column(
    children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        Text(elemento.tipo.toString()),
        Text(elemento.descripcion.toString()),
      ])
    ],
  );
}

Future<List<dynamic>> obtenerIdConvenioData(String idTipoConvenio) async {
  print(idTipoConvenio);
  String _url = '173.16.0.35:7001';
  final urlfintipoconvenio = Uri.http(
      _url,
      'fasesoft-web/webresources/servicios/fastiposconvenio/test/' +
          idTipoConvenio);
  final response = await http.get(urlfintipoconvenio);

  if (response.statusCode == 200) {
    debugPrint(response.body);
    final decodedidTipoData = json.decode(response.body);

    return decodedidTipoData;
  } else {
    throw Exception('error');
  }
}
