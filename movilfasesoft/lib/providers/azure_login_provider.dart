import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:movilfasesoft/main.dart';


class UserLogin {
  
  String _url='173.16.0.84:7001';
  static Config config = new Config(
      "bf208dcb-97e8-4d43-bd72-323680bef25c", //tenand id
      "19d6b921-44b0-42df-946f-d14bf3392cbf", //client id
      "openid profile offline_access",
      "https://login.live.com/oauth20_desktop.srf"); //URI

  final AadOAuth oauth = AadOAuth(
      config); //Configuracion de la instancia para AZURE ACTIVE DIRECTORY

  Future<String> azureLogin(context) async {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    oauth.setWebViewScreenSize(
        Rect.fromCenter(center: Offset(w / 2, h / 2), height: h, width: w));
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected');
        await oauth.login();

        String accessToken = await oauth.getAccessToken();
        //solicitar token como string
        var decodedToken = new JWT.parse(
            accessToken); //Decodificar token usando libreria corsac jwt
        //print(decodedToken.getClaim('upn'));//solicitar el claim 'upn' que es el id de correo en este caso.
        var correo= decodedToken.getClaim('upn');

        final url = Uri.http(_url,'fasesoft-web/webresources/servicios/fasusuarios/afiliadoPorCorreo/' + correo);
        //print(url);
        final resp = await http.get(url);

        if (resp.statusCode == HttpStatus.ok) {
          final decodedData = json.decode(resp.body);
          
          if(decodedData.isNotEmpty){
            if(decodedData[0]['estado']=='AFILIADO'){
              MyApp.correoUsuario=correo;
              return correo;
            }else{
              //print('no afiliado');
              return 'NA';
            }
          }else{
            //print('no registrado');
            return 'NR';
          }
        

      }
      }
    } on SocketException catch (_) {
      //print('not connected');
      return 'error';
    }
    //solicitar inicio de sesion
  }

  logOut(context) {
    MyApp.correoUsuario='';
    oauth.logout();
    Navigator.pushReplacementNamed(context, '/');
  }

  isloged() {
    //print(oauth.tokenIsValid());
    return oauth.tokenIsValid();
  }
}
