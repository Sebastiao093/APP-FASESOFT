import 'package:flutter/material.dart';

class Credito {
  final int idCredito;
  final num tasaReal;
  final num monto;
  final num saldo;
  //final DateTime fecha_inicio;  nullable
  //final DateTime fecha_desembolso; nullable
  //final DateTime fecha_inicio_pago; nullable
  //final int cuotas_pendientes;
  //final num pagare;
  final String estado;
  final String correo;
  final String nombretipodecredito;
  final String idtipodecredito;
  final String descripcion;
  final num numeroCuotas;
  final DateTime fechaSolicitud;
  final num mora;

  Credito(
      {@required this.idCredito,
      this.tasaReal,
      this.monto,
      this.saldo,
      this.estado,
      @required this.correo,
      @required this.nombretipodecredito,
      @required this.idtipodecredito,
      this.descripcion,
      this.fechaSolicitud,
      this.mora,
      this.numeroCuotas});


  factory Credito.fromJson(Map<String, dynamic> json) {
    return Credito(
      idCredito: json['idCredito'],
      tasaReal: json['tasaReal'],
      monto: json['monto'],
      saldo: json['saldo'],
      estado: json['estadoCredito'],
      correo: json['correo'],
      nombretipodecredito: json['tipo'],
      idtipodecredito: json['tipoId'],
      descripcion: json['descripcion'],
      fechaSolicitud: json['fechaSolicitud'],
      mora: json['mora'],
      numeroCuotas: json['cuotas'],
    );
  }
}
 