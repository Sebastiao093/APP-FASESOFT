import 'package:flutter/material.dart';
import 'package:movilfasesoft/widgets/WidgetPreguntaServicio.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PantallaVotaciones extends StatefulWidget {
  static const routedname = "/PantallaVotaciones";
  @override
  _PantallaVotacionesState createState() => _PantallaVotacionesState();
}

class _PantallaVotacionesState extends State<PantallaVotaciones> {
  int idAsambleaActual;
  @override
  Widget build(BuildContext context) {
    solicitarAsambleaActual().then((aux) {
      this.idAsambleaActual = aux;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Votaciones'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: WidgetPreguntaServicio(
          idAsambleaActual,
          solicitarPreguntasPorVotacion,
          solicitarRespuestasPorPregunta,
          enviarRespuestasPost),
    );
  }

  Future<int> solicitarAsambleaActual() async {
    String url =
        "http://173.16.0.84:7001/fasesoft-web/webresources/servicios/fasasambleas/AsambleaActual";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body)['idAsamblea'];
    } else {
      throw Exception('error');
    }
  }

  Future<List<dynamic>> solicitarPreguntasPorVotacion(String idAsamblea) async {
    String url =
        "http://173.16.0.84:7001/fasesoft-web/webresources/servicios/fasVotaciones/consultaId/" +
            idAsamblea;

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('error');
    }
  }

  Future<List<dynamic>> solicitarRespuestasPorPregunta(
      String idPregunta) async {
    String url =
        "http://173.16.0.84:7001/fasesoft-web/webresources/servicios/fasRespuestas/consultaId/" +
            idPregunta;

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('error');
    }
  }

  void enviarRespuestasPost(Map<String, dynamic> datoAenviar) async {
    String url =
        "http://173.16.0.84:7001/fasesoft-web/webresources/servicios/respuestaUsuario/agregar";

    var response = await http
        .post(Uri.encodeFull(url), body: json.encode(datoAenviar), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    });
    print(response.body);
  }

  void enviarRespuestasPut(Map<String, dynamic> datoAenviar) async {
    String url =
        "http://173.16.0.84:7001/fasesoft-web/webresources/servicios/fasasambleas";

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
