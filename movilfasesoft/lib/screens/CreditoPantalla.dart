import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:movilfasesoft/models/Credito.dart';

class CreditoPantalla extends StatefulWidget {
  static const routedname = "/PantallaCreditos";
  static var correo = "shgarcia@asesoftware.com";

  @override
  _CreditoPantallaState createState() => _CreditoPantallaState(userData: obtenerData());
}

Future<List<dynamic>> obtenerData() async {
  String correo = "shgarcia@asesoftware.com";
  String _url = '173.16.0.84:7001';
    final urlfin = Uri.http(_url,'fasesoft-web/webresources/servicios/fascreditos/historial/shgarcia@asesoftware.com');
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

class _CreditoPantallaState extends State<CreditoPantalla> {

  Future<List<dynamic>> userData;

  _CreditoPantallaState({this.userData});

  @override
  Widget build(BuildContext context) {
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

        return Text(elemento.fechaSolicitud);
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
        }
        return CircularProgressIndicator();
      },
    ),
  );
}

}
