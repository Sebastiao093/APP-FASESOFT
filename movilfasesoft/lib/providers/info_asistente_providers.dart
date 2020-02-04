// import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/infoAsistente.dart';
import 'package:movilfasesoft/providers/providers_config.dart';
import 'package:movilfasesoft/utils/miExcepcion.dart';

class InfoAsistenteProvider {
  final String dominio = 'sarapdev.eastus.cloudapp.azure.com:7001';
  final String path = 'fasesoft-web/webresources/servicios/';
  final String pathServicio = 'fasasistentes/';

  String fecha = DateFormat.y().format(DateTime.now());
  Future<InfoAsistente> getInfoAsistente(String correo) async {
    final String pathAsistentes ='asistenciaPorFechaCorreo/' + fecha + '/' + correo;
    final url = Uri.http(ProviderConfig.url,ProviderConfig.path + pathServicio + pathAsistentes);
    InfoAsistente infoasistente;
    List<dynamic> decodedData;
    try {
      final respuestaHttp = await http.get(url);
      decodedData = json.decode(utf8.decode(respuestaHttp.bodyBytes));
    } catch (e) {
      throw MiException(errorCode: 200);
    }
    if (decodedData.length > 0) {
      infoasistente = InfoAsistente.fromJson(decodedData[0]);
      return infoasistente;
    } else {
      throw MiException(errorCode: 100);
    }
  }
}
