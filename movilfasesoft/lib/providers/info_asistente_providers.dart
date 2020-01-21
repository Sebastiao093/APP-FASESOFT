import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class InfoAsistenteProvider {
  final String dominio='173.16.0.84:7001';
  final String path='fasesoft-web/webresources/servicios/fasasistentes/';
  
  String fecha = DateFormat.y().format(DateTime.now());
  
  Future<List<dynamic>> getInfoAsistente(String correo) async {
    final String pathAsistentes='asistenciaPorFechaCorreo/'+fecha+'/'+correo;
    final url = Uri.http(dominio, path+pathAsistentes);
    print('Direccion: $url');

    final respuestaHttp = await http.get(url);
    print(respuestaHttp.statusCode);
    if (respuestaHttp.statusCode == 200) {
      final decodedData = json.decode(respuestaHttp.body);
      debugPrint(decodedData);

      return decodedData;
    } else {
      throw Exception('error');
    }
  }
}