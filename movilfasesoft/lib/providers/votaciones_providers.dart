
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



class Votaciones_providers{


   static Future<int> solicitarAsambleaActual() async {
    String url =
        "http://sarapdev.eastus.cloudapp.azure.com:7001/fasesoft-web/webresources/servicios/fasasambleas/AsambleaActual";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body)['idAsamblea'];
    } else {
      throw Exception('error');
    }
  }

  static Future<List<dynamic>> solicitarPreguntasPorVotacion(String idAsamblea) async {
    String url =
        "http://sarapdev.eastus.cloudapp.azure.com:7001/fasesoft-web/webresources/servicios/fasVotaciones/consultaId/" +
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
        "http://sarapdev.eastus.cloudapp.azure.com:7001/fasesoft-web/webresources/servicios/fasRespuestas/consultaId/" +
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
        "http://sarapdev.eastus.cloudapp.azure.com:7001/fasesoft-web/webresources/servicios/respuestaUsuario/agregar";

    var response = await http
        .post(Uri.encodeFull(url), body: json.encode(datoAenviar), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    });
    print(response.body);
  }

  static void enviarRespuestasPut(Map<String, dynamic> datoAenviar) async {
    String url =
        "http://sarapdev.eastus.cloudapp.azure.com:7001/fasesoft-web/webresources/servicios/fasasambleas";

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