import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ConvenioPantalla extends StatefulWidget {

  static const routedname = "/PantallaConvenios";
  static var correo = "shgarcia@asesoftware.com";

  @override
  _ConvenioPantallaState createState() => _ConvenioPantallaState();
}

class _ConvenioPantallaState extends State<ConvenioPantalla> {
  
  static var correo = "shgarcia@asesoftware.com";
  String _url = '173.16.0.35:7001';

  Future<List<dynamic>> obtenerData() async {
  final urlfin = Uri.http(_url,'fasesoft-web/webresources/servicios/fasconvenios/misconvenios',{'correo':'shgarcia@asesoftware.com'});
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
        title: Text('Convenios'),
      ),
      body: Text('Convenios'),

    );
  }
}