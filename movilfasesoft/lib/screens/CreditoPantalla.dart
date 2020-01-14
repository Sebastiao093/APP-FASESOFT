import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:movilfasesoft/models/Credito.dart';

class CreditoPantalla extends StatefulWidget {
  static const routedname = "/PantallaCreditos";
  @override
  _CreditoPantallaState createState() => _CreditoPantallaState();
}

class _CreditoPantallaState extends State<CreditoPantalla> {
  static var correo = "shgarcia@asesoftware.com";
  String _url = '173.16.0.35:7001';
  List userData;

  Future<List<dynamic>> obtenerData() async {
    final urlfin = Uri.http(_url,
        'fasesoft-web/webresources/servicios/fascreditos/historial/shgarcia@asesoftware.com');
    //print(urlfin);
    final response = await http.get(urlfin);

    if (response.statusCode == 200) {
      debugPrint(response.body);
      final decodedData = json.decode(response.body);

      setState(() {
        userData = barrido(decodedData["data"]);
        print(Credito.fromJson(userData.first));
      });

      return decodedData;
    } else {
      throw Exception('error');
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Creditos'),
      ),
      body: _cargarCreditos(),
    );
  }

  Widget _cargarCreditos(){

    return ListView.builder(
      itemCount: userData == null ? 0 : userData.length,
      itemBuilder: (BuildContext context, int index){
        
        return Card(

          child: Column(
            children: <Widget>[
              

            ],
          ),
          
          
          

        );

      },

    );

  }

  List<Credito> barrido(List<Map<String, dynamic>> dato){
    return dato.map((aux){
      return Credito.fromJson(aux);
    }).toList();
  }


}
