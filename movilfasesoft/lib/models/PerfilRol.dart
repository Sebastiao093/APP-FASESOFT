import 'package:flutter/material.dart';
      
class PerfilRol {
  
  final num idPerfil;
  final num idUsuario;
  final String tipo;
    
  PerfilRol({
  this.idPerfil,
  this.idUsuario,
  @required this.tipo,
  });
     
  factory PerfilRol.fromJson( Map<String, dynamic> json){
    return PerfilRol(
      idPerfil    : json['idPerfil'],
      idUsuario   : json['idUsuario'],
      tipo        : json['tipo'],
    );
  }
}