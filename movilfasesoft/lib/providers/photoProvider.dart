
import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/main.dart';
import 'package:movilfasesoft/models/usuario.dart';

class PhotoProvider {
 
  final List<ListTile> usuario1 =List();


  String _url='graph.microsoft.com/v1.0/users/';
 

     Future<UsuarioAres> getUserphoto(String correo) async{
  

    
    http.get(
    _url+correo+'/photo/\$VALUE',
    // Send authorization headers to the backend.
    headers: {HttpHeaders.authorizationHeader: MyApp.token},
  );
    
  //   final resp = await http.get(url);
    
  //   if (resp.statusCode==HttpStatus.ok){
  //     final decodedData= json.decode(resp.body);
  //     user= UsuarioAres.fromJson(decodedData[0]);

  //  }else{
  //      print('error en http');
  //  }


 
    //print(user.nombre +' '+user.identificacion);
  
    return null;

 
  }
     
  
  }
