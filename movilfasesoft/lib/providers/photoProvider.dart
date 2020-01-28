
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/main.dart';

Widget userPhoto(correo) {
 

  String _url='Https://graph.microsoft.com/v1.0/users/';
 
 return Container(
      width: 100.0,
      height: 100.0,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
          fit: BoxFit.fill,
          image:  NetworkImage(
        _url+correo+'/photo/\$VALUE' ,
        headers: {HttpHeaders.authorizationHeader: MyApp.token},
    ),
   
                 )
)
);
  }


