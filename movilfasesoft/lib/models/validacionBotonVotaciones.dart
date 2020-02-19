import 'package:flutter/material.dart';

class ValidacionBotonVotaciones{
  bool hayAsamblea;
  bool preguntasPorContestar;
  bool asistio;

  ValidacionBotonVotaciones({
    @required this.hayAsamblea,
    @required this.preguntasPorContestar,
    @required this.asistio
  });

factory ValidacionBotonVotaciones.fromJson(Map<String, dynamic> json) {
    return ValidacionBotonVotaciones(
      hayAsamblea           : json['hayAsamblea'],
      preguntasPorContestar : json['preguntasPorContestar'],
      asistio               : json['asistio']
    );
  }
}