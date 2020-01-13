import 'package:flutter/material.dart';
import '../models/Respuesta.dart';
import '../widgets/temporalPreguntas.dart';
import '../models/Pregunta.dart';

List<Pregunta> conversionAclases(List<Map<String, Object>> preguntasEntrada) {
   return  preguntasEntrada.map((preguntaIndex) {
    return Pregunta(
      pregunta: preguntaIndex['laPregunta'],
      respuestas:  (preguntaIndex['lasRespuestas'] as List<String>).map((aux) {
      return Respuesta(respuesta: aux);
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
  final List<Pregunta> preguntasAvotar = conversionAclases(preguntasConstantes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Votaciones'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: preguntasAvotar.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    preguntasAvotar.elementAt(index).pregunta,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Column(children: preguntasAvotar.elementAt(index).respuestas.map((respuestaUnitaria){
                    return Text(respuestaUnitaria.respuesta);
                  }).toList(),)

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
