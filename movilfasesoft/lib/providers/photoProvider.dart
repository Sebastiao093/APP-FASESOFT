
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:movilfasesoft/main.dart';

Widget userPhoto(correo) {
 
  String _url='Https://graph.microsoft.com/v1.0/users/';
 
  return  ClipRRect(
   borderRadius: BorderRadius.circular(100),
   child:FadeInImage(
     placeholder: AssetImage('assets/icons/person.png'),
     image:  NetworkImage(_url+correo+'/photo/\$VALUE', headers: {HttpHeaders.authorizationHeader: MyApp.token},)
    ),
  );
}