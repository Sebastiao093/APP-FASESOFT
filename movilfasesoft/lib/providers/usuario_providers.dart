import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/usuario.dart';

class UserProvider {
  final List<ListTile> usuario1 =List();

  String _url='173.16.0.100:7001';

  getusername(String user1){
    getUser(user1).then((onValue){
    var onValue2 = onValue;
        return onValue2.identificacion;
    });
    
    }
     Future<UsuarioAres> getUser(String user1) async{
    print('entro');

    final url= Uri.http(_url,'fasesoft-web/webresources/servicios/fasafiliados/detalleUsuarioAres/'+ user1);
    print(url);
    final resp = await http.get(url);
    final decodedData= json.decode(resp.body);
   
    UsuarioAres user= UsuarioAres.fromJson(decodedData[0]);
    //print(user.nombre +' '+user.identificacion);
  
    return user;

 
  }
     
  
  }