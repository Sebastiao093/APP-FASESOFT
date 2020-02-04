import 'package:flutter/material.dart';

class Convenio {
  final int idConvenio;
  final num saldo;
  final String estado;
  final num numeroCuotas;
  final num mora;
  final int idtipoconvenio;
  final String fechaSolicitud;
  final num cuotasPendientes;
  final num cuotasIntereses;
  final num cuotaSeguro;
  final num cuotaAporte;
  final num monto;
  String nombre;
  String descripcion;

  Convenio(
    {@required this.idConvenio,
    this.saldo,
    this.estado,
    this.numeroCuotas,
    this.mora,
    @required this.idtipoconvenio,
    this.fechaSolicitud,
    this.cuotasPendientes,
    this.cuotasIntereses,
    this.cuotaSeguro,
    this.cuotaAporte,
    this.monto
    }
  );

  factory Convenio.fromJson(Map<String, dynamic> json) {
    return Convenio(
      idConvenio        : json['idConvenio'],
      saldo             : json['saldo'],
      estado            : json['estado'],
      numeroCuotas      : json['numeroCuotas'],
      mora              : json['mora'],
      idtipoconvenio    : json['fasTipoConvIdTipoConv'],
      fechaSolicitud    : json['fechaSolicitud'],
      cuotasPendientes  : json['cuotasPendientes'],
      cuotasIntereses   : json['cuotasIntereses'],
      cuotaSeguro       : json['cuotaSeguro'],
      cuotaAporte       : json['cuotaAporte'],
      monto             : json['monto'],
    );
  }
}