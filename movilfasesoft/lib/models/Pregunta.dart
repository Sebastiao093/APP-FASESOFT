import 'package:flutter/material.dart';
import './respuesta.dart';

class Pregunta {
final String pregunta;
final List<Respuesta> respuestas;

Pregunta({
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