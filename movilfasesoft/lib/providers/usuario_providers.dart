
import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/usuario.dart';

class UserProvider {
  final List<ListTile> usuario1 =List();


  String _url='sarapdev.eastus.cloudapp.azure.com:7001';

  getusername(String user1){
    getUser(user1).then((onValue){
    var onValue2 = onValue;
        return onValue2.identificacion;
    });
    
    }
     Future<UsuarioAres> getUser(String user1) async{
    //print('entro');
    UsuarioAres user;

    final url= Uri.http(_url,'fasesoft-web/webresources/servicios/fasafiliados/detalleUsuarioAres/'+user1);
    print(url);
    final resp = await http.get(url);
    
    if (resp.statusCode==HttpStatus.ok){
      final decodedData= json.decode(resp.body);
      user= UsuarioAres.fromJson(decodedData[0]);

   }else{
       print('error en http');
   }


 
    //print(user.nombre +' '+user.identificacion);
  
    return user;

 
  }
     
  
  }