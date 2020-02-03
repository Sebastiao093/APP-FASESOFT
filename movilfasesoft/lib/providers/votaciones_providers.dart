
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/validacionBotonVotaciones.dart';
import 'package:movilfasesoft/providers/providers_config.dart';



class Votaciones_providers{


  static Future<ValidacionBotonVotaciones> getValidacionBotonVotaciones(String correo) async {
    String fecha = DateFormat.y().format(DateTime.now());
    final String pathValidacion='fasVotaciones/ValidacionBotonVotaciones/'+fecha+'/'+correo;
    final url = Uri.http(ProviderConfig.url, ProviderConfig.path+pathValidacion);
    ValidacionBotonVotaciones validacionBotonVotaciones=new ValidacionBotonVotaciones(asistio: false,hayAsamblea: false,preguntasPorContestar: false);

    final respuestaHttp = await http.get(url);
    
    if (respuestaHttp.statusCode == 200) {
      final decodedData = json.decode(respuestaHttp.body);
      validacionBotonVotaciones = ValidacionBotonVotaciones.fromJson(decodedData);

    } else {
      throw Exception('error');
    }
    return validacionBotonVotaciones;

  }

  static Future<List<dynamic>> solicitarRespuestasContestadas(String idasistente) async {
    final String pathRespuestaUsuario="respuestaUsuario/consultaListaCompleta/" + idasistente;
    final url = Uri.http(ProviderConfig.url, ProviderConfig.path+pathRespuestaUsuario);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('error');
    }
  }


  static Future<List<dynamic>> solicitarPreguntasPorVotacion(String idAsamblea) async {
    final String pathFasVotaciones ="fasVotaciones/consultaId/" + idAsamblea;
    final url = Uri.http(ProviderConfig.url, ProviderConfig.path+ pathFasVotaciones);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('error');
    }
  }

 static Future<List<dynamic>> solicitarRespuestasPorPregunta(
      String idPregunta) async {
    String pathFasRespuestas = "fasRespuestas/consultaId/" +idPregunta;
    final url = Uri.http(ProviderConfig.url, ProviderConfig.path+ pathFasRespuestas);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('error');
    }
  }

  static Future<dynamic> enviarRespuestasPost(Map<String, dynamic> datoAenviar) async {
    String pathRespuestasUsuario ="respuestaUsuario/agregar";
    
    final url = "http://"+ProviderConfig.url+"/"+ProviderConfig.path+ pathRespuestasUsuario;
    
    final response = await http
        .post(Uri.encodeFull(url), body: json.encode(datoAenviar), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('error');
    }
  }


}