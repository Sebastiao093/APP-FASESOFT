import 'package:flutter/material.dart';
import './Respuesta.dart';

class Pregunta {
final int id;
final String pregunta;
final List<Respuesta> respuestas;
//final String respuestas;

Pregunta({
  @required this.id,
 @required this.pregunta,
 @required this.respuestas
});

factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      pregunta: json['laPregunta'],
      respuestas: json['lasRespuestas']
    );
  }

}