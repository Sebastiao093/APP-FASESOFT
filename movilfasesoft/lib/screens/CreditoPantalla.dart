import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class CreditoPantalla extends StatefulWidget {
  static const routedname = "/PantallaConvenios";
  @override
  _CreditoPantallaState createState() => _CreditoPantallaState();
}

class _CreditoPantallaState extends State<CreditoPantalla> {
  
  static var correo = "shgarcia@asesoftware.com";
  String url = "http://localhost:7001/fasesoft-web/webresources/servicios/fascreditos/historial/$correo";

  Future obtenerData() async {
    http.Response response = await http.get("url");
    debugPrint(response.body);
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