import 'package:flutter/material.dart';

class TipoConvenio {
  final int idTipoConvenio;
  final String tipo;
  final String descripcion;
  final String estado;
  final String urlConvenio;
  final num tasa;
  final num cuotasMaximas;

  TipoConvenio({
    @required this.idTipoConvenio,
    this.tipo,
    this.descripcion,
    this.estado,
    this.urlConvenio,
    this.tasa,
    this.cuotasMaximas
  });

  factory TipoConvenio.fromJson(Map<String, dynamic> json) {
    return TipoConvenio(
      idTipoConvenio  : json['idTipoConvenio'],
      tipo            : json['tipo'],
      descripcion     : json['descripcion'],
      estado          : json['estado'],
      urlConvenio     : json['urlConvenio'],
      tasa            : json['tasa'],
      cuotasMaximas   : json['cuotasMaximas'],
    );
  }
}