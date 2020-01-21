/*class InfoAsistentes{
  List<InfoAsistente> info = new List();

  InfoAsistentes();

  InfoAsistentes.fromJsonList( List<dynamic> listInfoAsistenteFromJson){
    
    if(listInfoAsistenteFromJson == null) return;
    for (var item in listInfoAsistenteFromJson) {
      final infoAsistente = new InfoAsistente.fromJsonMap(item);
      info.add(infoAsistente);
    }
  }
      
}*/

import 'package:flutter/material.dart';
      
class InfoAsistente {
  String apellido;
  String correo;
  String estado;
  int idAsamblea;
  int idAsistente;
  int idUsuario;
  String nombre;
    
  InfoAsistente({
  this.apellido,
  this.correo,
  this.estado,
  this.idAsamblea,
  this.idAsistente,
  this.idUsuario,
  this.nombre,
  });
     
  factory InfoAsistente.fromJson( Map<String, dynamic> json){
    return InfoAsistente(
      apellido    : json['apellido'],
      correo      : json['correo'],
      estado      : json['estado'],
      idAsamblea  : json['idAsamblea'],
      idAsistente : json['idAsistente'],
      idUsuario   : json['idUsuario'],
      nombre      : json['nombre'],
    );
  }
}
 