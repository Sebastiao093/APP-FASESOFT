import 'package:flutter/cupertino.dart';

class Respuesta {
final int id;
final String respuesta;
Respuesta({@required this.id,@required this.respuesta});


factory Respuesta.fromJson(Map<String, dynamic> json) {
    return Respuesta(
      id: json['idRespuesta'],
      respuesta: json['respuesta'],
    );
  }

}