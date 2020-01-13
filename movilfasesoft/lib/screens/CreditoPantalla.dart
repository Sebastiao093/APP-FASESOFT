import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class CreditoPantalla extends StatefulWidget {
  static const routedname = "/PantallaCreditos";
  @override
  _CreditoPantallaState createState() => _CreditoPantallaState();
}

class _CreditoPantallaState extends State<CreditoPantalla> {
  
  static var correo = "shgarcia@asesoftware.com";
  String _url = '173.16.0.35:7001';

  Future<List<dynamic>> obtenerData() async {
  final urlfin = Uri.http(_url,'fasesoft-web/webresources/servicios/fascreditos/historial/shgarcia@asesoftware.com');
  print(urlfin);
  final response = await http.get(urlfin);

  if (response.statusCode == 200) {
    debugPrint(response.body);
    final decodedData = json.decode(response.body);
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
      body: Text('Creditos'),
    );
  }
}







/*class CreditoPantalla extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Creditos'),
      ),
      body: Text('Creditos'),
      
    );
  }
}*/