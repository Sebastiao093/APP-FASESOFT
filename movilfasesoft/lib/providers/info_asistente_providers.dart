// import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/infoAsistente.dart';

class InfoAsistenteProvider {
 
 
 //final String dominio='sarapdev.eastus.cloudapp.azure.com:7001';
  final String dominio = '173.16.0.84:7001';
  final String path='fasesoft-web/webresources/servicios/fasasistentes/';
  
  String fecha = DateFormat.y().format(DateTime.now());
  
  Future<InfoAsistente> getInfoAsistente(String correo) async {
    final String pathAsistentes='asistenciaPorFechaCorreo/'+fecha+'/'+correo;
    final url = Uri.http(dominio, path+pathAsistentes);
    print('Direccion: $url');
    InfoAsistente infoasistente;

    final respuestaHttp = await http.get(url);
    
    if (respuestaHttp.statusCode == 200) {
      final decodedData = json.decode(respuestaHttp.body);
      infoasistente = InfoAsistente.fromJson(decodedData[0]);

      //return decodedData;
    } else {
      throw Exception('error');
    }

    return infoasistente;

  }
}