
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/main.dart';

Widget userPhoto(context,correo) {
 

  String _url='Https://graph.microsoft.com/v1.0/users/';
 
 return  ClipRRect(
   borderRadius: BorderRadius.circular(80),
   child:FadeInImage(
     placeholder: AssetImage('assets/icons/person.png'),
     image:  NetworkImage(
        _url+correo+'/photo/\$VALUE' ,
        headers: {HttpHeaders.authorizationHeader: MyApp.token},
      )
    ),
   );
      
   

  }

