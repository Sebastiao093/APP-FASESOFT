import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:movilfasesoft/models/Credito.dart';
import 'package:movilfasesoft/models/usuario.dart';

class CreditoPantalla extends StatefulWidget {
  static const routedname = "/PantallaCreditos";
  static var correo = "shgarcia@asesoftware.com";

  @override
  _CreditoPantallaState createState() => _CreditoPantallaState();
}

Future<List<dynamic>> obtenerData(String correo) async {
  print(correo);
  String _url = '173.16.0.35:7001';
    final urlfin = Uri.http(_url,'fasesoft-web/webresources/servicios/fascreditos/historial/'+ correo);
    //print(urlfin);
    final response = await http.get(urlfin);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      
      return decodedData;
    } else {
      throw Exception('error');
    }
  }

class _CreditoPantallaState extends State<CreditoPantalla> {

  

  @override
  Widget build(BuildContext context) {
    String usuarioCorreo = ModalRoute.of(context).settings.arguments as String; 
    Future<List<dynamic>> userData = obtenerData(usuarioCorreo);
    return Scaffold(
      appBar: AppBar(
        title: Text('Creditos'),
      ),
      body: Center(
      child: contenido1(userData),
      ),
    );
  }

  Widget ElementosCartas(Credito elemento) {

        return Card(
          elevation: 10.0,
          margin: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(elemento.nombretipodecredito),
                  Text(elemento.descripcion)
                ],
              ),
              Text(elemento.fechaSolicitud.substring(0,10)),
              Text(elemento.estado)
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
              var elemento = new Credito.fromJson(
                  auxElementos.data.elementAt(index) as Map<String, dynamic>);
                  
              return ElementosCartas(elemento);
            },
          );
        } else if (auxElementos.hasError) {
          return Text('${auxElementos.error}');
        } else if (!auxElementos.hasData) {
          return Card(
          child: Column(
            children: <Widget>[
              Text('No tienes Creditos con nosotros, adquiere uno con nosotros')
            ],
          ),
        );
        } 
        return CircularProgressIndicator();
      },
    ),
  );
}

}
