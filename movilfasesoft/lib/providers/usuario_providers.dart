
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';


class UsuarioProviders {

final String dominio='173.16.0.185:7001';
final pathUsuarioFromAres='/fasesoft-web/webresources/servicios/fasafiliados/detalleUsuarioAres/';


Future<UsuarioAres>  getUsuario(String correo) async {
  
   final urii= Uri.http(dominio,pathUsuarioFromAres+correo);
   final respuesta=await http.get(urii);
   
   if (respuesta.statusCode!=200){
     print('error en respuesta http');

   }
    final jsonDecodeData=json.decode(respuesta.body);
    final user2=UsuariosFromAres.fromList(jsonDecodeData);

    
  return (user2.usuarios[0]);
}