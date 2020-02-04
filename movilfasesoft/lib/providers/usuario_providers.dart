
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/usuario.dart';
import 'package:movilfasesoft/providers/providers_config.dart';
import 'package:movilfasesoft/utils/miExcepcion.dart';

class UserProvider {
  final List<ListTile> usuario1 =List();
  final String pathServicio='fasafiliados/detalleUsuarioAres/';

  getusername(String user1){
    getUser(user1).then((onValue){
    var onValue2 = onValue;
        return onValue2.identificacion;
    });
  }
  Future<UsuarioAres> getUser(String user1) async{
    
    UsuarioAres user;
    final url= Uri.http(ProviderConfig.url,ProviderConfig.path+pathServicio+user1);
    final resp = await http.get(url);
    if (resp.statusCode==HttpStatus.ok){
      final decodedData= json.decode(utf8.decode(resp.bodyBytes));
      user= UsuarioAres.fromJson(decodedData[0]);
    }else{
      throw new MiException( errorCode: 200);
    }
    return user;
  }
}