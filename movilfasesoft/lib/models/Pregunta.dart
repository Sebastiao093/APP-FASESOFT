import 'package:flutter/material.dart';
import './Respuesta.dart';

class Pregunta {
final int id;
final String pregunta;
//final String respuestas;

Pregunta({
  @required this.id,
 @required this.pregunta
});

factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      id: json['idVotacion'],
      pregunta: json['pregunta'],
    );
  }

}