import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/PerfilRol.dart';
import 'package:movilfasesoft/providers/providers_config.dart';
import 'package:movilfasesoft/utils/miExcepcion.dart';

class PerfilRolProvider {
  final String dominio='sarapdev.eastus.cloudapp.azure.com:7001';
  final String pathServicio ='fasusuarios/perfilPorCorreo/';

  Future<PerfilRol> getPerfilRol(String correo) async {
    final String pathPerfilRol = '' + correo;
    final url = Uri.http(ProviderConfig.url,ProviderConfig.path+pathServicio + pathPerfilRol);
    PerfilRol perfilRol;
    final respuestaHttp = await http.get(url);

    if (respuestaHttp.statusCode == 200) {
      final decodedData = json.decode(utf8.decode(respuestaHttp.bodyBytes));
      perfilRol = PerfilRol.fromJson(decodedData[0]);
    } else {
      throw new MiException( errorCode: 200);
    }
    return perfilRol;
  }
}