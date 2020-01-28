import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/PerfilRol.dart';

class PerfilRolProvider {
  //final String dominio='sarapdev.eastus.cloudapp.azure.com:7001';
  final String dominio = '173.16.0.44:7001';
  final String path =
      'fasesoft-web/webresources/servicios/fasusuarios/perfilPorCorreo/';

  Future<PerfilRol> getPerfilRol(String correo) async {
    final String pathPerfilRol = '' + correo;
    final url = Uri.http(dominio, path + pathPerfilRol);
    print('Direccion: $url');
    PerfilRol perfilRol;

    final respuestaHttp = await http.get(url);

    if (respuestaHttp.statusCode == 200) {
      final decodedData = json.decode(respuestaHttp.body);
      perfilRol = PerfilRol.fromJson(decodedData[0]);
    } else {
      throw Exception('error');
    }
    return perfilRol;
  }
}
