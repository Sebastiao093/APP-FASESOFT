
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/RespuestaContestadas.dart';
import 'package:movilfasesoft/models/validacionBotonVotaciones.dart';



class Votaciones_providers{

  //static String dominio='sarapdev.eastus.cloudapp.azure.com:7001';
  static final String dominio = '173.16.0.84:7001';
  static final String path='fasesoft-web/webresources/servicios/fasVotaciones/';

  
  static Future<ValidacionBotonVotaciones> getValidacionBotonVotaciones(String correo) async {
    String fecha = DateFormat.y().format(DateTime.now());
    final String pathValidacion='ValidacionBotonVotaciones/'+fecha+'/'+correo;
    final url = Uri.http(dominio, path+pathValidacion);
    ValidacionBotonVotaciones validacionBotonVotaciones=new ValidacionBotonVotaciones(asistio: false,hayAsamblea: false,preguntasPorContestar: false);

    final respuestaHttp = await http.get(url);
    
    if (respuestaHttp.statusCode == 200) {
      final decodedData = json.decode(respuestaHttp.body);
      validacionBotonVotaciones = ValidacionBotonVotaciones.fromJson(decodedData);

      //return decodedData;
    } else {
      throw Exception('error');
    }

    return validacionBotonVotaciones;

  }

  static Future<List<dynamic>> solicitarRespuestasContestadas(String idasistente) async {
    String url =
        "http://"+Votaciones_providers.dominio+"/fasesoft-web/webresources/servicios/respuestaUsuario/consultaListaCompleta/" +
            idasistente;

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('error');
    }
  }


  static Future<List<dynamic>> solicitarPreguntasPorVotacion(String idAsamblea) async {
    String url =
        "http://"+Votaciones_providers.dominio+"/fasesoft-web/webresources/servicios/fasVotaciones/consultaId/" +
            idAsamblea;

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('error');
    }
  }

 static Future<List<dynamic>> solicitarRespuestasPorPregunta(
      String idPregunta) async {
    String url =
        "http://"+Votaciones_providers.dominio+"/fasesoft-web/webresources/servicios/fasRespuestas/consultaId/" +
            idPregunta;

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('error');
    }
  }

  static void enviarRespuestasPost(Map<String, dynamic> datoAenviar) async {
    String url =
        "http://"+Votaciones_providers.dominio+"/fasesoft-web/webresources/servicios/respuestaUsuario/agregar";

    var response = await http
        .post(Uri.encodeFull(url), body: json.encode(datoAenviar), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    });
    print('respuesta post: ${response.body}');
  }

  static void enviarRespuestasPut(Map<String, dynamic> datoAenviar) async {
    String url =
        "http://"+Votaciones_providers.dominio+"/fasesoft-web/webresources/servicios/fasasambleas";

    var response = await http.put(
      Uri.encodeFull(url),
      body: json.encode(datoAenviar),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
  }
}