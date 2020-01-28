import 'package:flutter/material.dart';

class RespuestasContestadas {
  String correo;
  int fkasistencia;
  String idrespuesta;
  int fkVotacion;

 RespuestasContestadas(
   {this.correo,this.fkasistencia,this.idrespuesta,this.fkVotacion}
 );

  factory RespuestasContestadas.fromJson(Map<String, dynamic> json) {
    return RespuestasContestadas(
        correo: json['correo'],
        fkasistencia:json['fkasistencia'],
        fkVotacion: json['FKVOTACION'],
        idrespuesta: json['idrespuesta'] );
  }
}
