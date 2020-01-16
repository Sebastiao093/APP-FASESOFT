import 'package:flutter/material.dart';
import '../widgets/WidgetPregunta.dart';
import '../models/Respuesta.dart';
import '../widgets/temporalPreguntas.dart';
import '../models/Pregunta.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<Pregunta> conversionAclases(List<Map<String, Object>> preguntasEntrada) {
  return preguntasEntrada.map((preguntaIndex) {
    return Pregunta(
      id: preguntaIndex['id'],
      pregunta: preguntaIndex['laPregunta'],
      respuestas: (preguntaIndex['lasRespuestas'] as List<Map<String, Object>>)
          .map((aux) {
        return Respuesta(id: aux['id'], respuesta: aux['titulo']);
      }).toList(),
    );
  }).toList();
}

class PantallaVotaciones extends StatefulWidget {
  static const routedname = "/PantallaVotaciones";
  @override
  _PantallaVotacionesState createState() => _PantallaVotacionesState();
}

class _PantallaVotacionesState extends State<PantallaVotaciones> {
  //final Future<List<dynamic>> preguntasAvotar;
  //PantallaVotaciones({Key key, this.preguntasAvotar}) : super(key: key);

  Future<List<dynamic>> solicitarDatosVotacion() async {
  String url =
      "http://173.16.0.84:7001/fasesoft-web/webresources/servicios/fasasambleas";
  final response = await http.get(url);

  if (response.statusCode == 200) {
    print( json.decode(response.body));
    return json.decode(response.body);
  } else {
    throw Exception('error');
  }
}

void enviarRespuestasPost(Map<String, dynamic> datoAenviar) async {
    String url =
        "http://173.16.0.84:7001/fasesoft-web/webresources/servicios/fasasambleas";
   

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
    
    var response = await http
        .put(Uri.encodeFull(url), body: json.encode(datoAenviar), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    },);
    print(response.body);

  }


   List<Pregunta> _preguntasAvotar =
      conversionAclases(preguntasConstantes);
       // Future<List<dynamic>>  _preguntasAvotar = solicitarDatosVotacion();//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Votaciones'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _preguntasAvotar = conversionAclases(preguntasConstantes);
              });
            },
          ),
        ],
      ),
      body: WidgetPregunta(_preguntasAvotar),
    );
  }
}


Widget WidgetPreguntaServicio2(Future<List<dynamic>>  preguntasAvotar,BuildContext ctx){

  return FutureBuilder<List<dynamic>>(
      future: preguntasAvotar,
      builder: (context, auxPregunta) {
        if (auxPregunta.hasData) {
          //Elemento element = new Elemento(auxElementos.data.first as Map<String,Dynamic>);
          return WidgetPregunta(auxPregunta.data) ;
        } else if (auxPregunta.hasError) {
          return Text('${auxPregunta.error}');
        }
        return CircularProgressIndicator();
      },
    );
}

