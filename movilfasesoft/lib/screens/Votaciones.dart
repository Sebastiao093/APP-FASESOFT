import 'package:flutter/material.dart';
import 'package:movilfasesoft/widgets/WidgetPregunta.dart';
import '../models/Respuesta.dart';
import '../widgets/temporalPreguntas.dart';
import '../models/Pregunta.dart';

List<Pregunta> conversionAclases(List<Map<String, Object>> preguntasEntrada) {
   return  preguntasEntrada.map((preguntaIndex) {
    return Pregunta(
      id: preguntaIndex['id'],
      pregunta: preguntaIndex['laPregunta'],
      respuestas:  (preguntaIndex['lasRespuestas'] as List<Map<String,Object>>).map((aux) {
      return Respuesta(id:aux['id']  ,respuesta: aux['titulo']);
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
  final List<Pregunta> _preguntasAvotar = conversionAclases(preguntasConstantes);

  void reinico(){
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Votaciones'),
        actions: <Widget>[
         IconButton(
            icon: Icon(Icons.refresh),
            onPressed: ()=>reinicio(),
          ),
        ],
      ),
      body: WidgetPregunta(_preguntasAvotar),
    );
  }
}
