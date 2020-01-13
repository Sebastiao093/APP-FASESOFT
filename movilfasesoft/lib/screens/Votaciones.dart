import 'package:flutter/material.dart';
import 'package:movilfasesoft/models/Respuesta.dart';
import '../widgets/temporalPreguntas.dart';
import '../models/Pregunta.dart';



List<Pregunta> conversionAclases(List<dynamic> preguntasEntrada){

  return preguntasEntrada.map((preguntaIndex){
    return Pregunta(pregunta: preguntaIndex['laPregunta'],
     respuestas: preguntaIndex['lasRespuestas'].map((respuestaIndex){
       return Respuesta(respuesta: respuestaIndex);
     }).tolist());
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
  final List<Map<String, Object>> preguntasAvotar = preguntasConstantes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Votaciones'),
      ),
      body: Center(
        child: Text('hola'),
      ),
    );
  }
}
