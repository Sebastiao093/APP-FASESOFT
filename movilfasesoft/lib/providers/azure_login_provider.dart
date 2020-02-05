import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:movilfasesoft/main.dart';
import 'package:movilfasesoft/providers/providers_config.dart';

class UserLogin {
  final String servicioPath='fasusuarios/afiliadoPorCorreo/';
   
  static Config config = new Config(
    "bf208dcb-97e8-4d43-bd72-323680bef25c", //tenand id
    "19d6b921-44b0-42df-946f-d14bf3392cbf", //client id
    "openid profile offline_access",
    "https://login.live.com/oauth20_desktop.srf"); //URI

  final AadOAuth oauth = AadOAuth(config); //Configuracion de la instancia para AZURE ACTIVE DIRECTORY

  Future<String> azureLogin(context) async {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    var conexion=false;
    oauth.setWebViewScreenSize(Rect.fromCenter(center: Offset(w / 2, (h/ 2)+h*.05), height: h*.9, width: w));
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) { 
        conexion=true;
      }
    } on SocketException catch (_) {
      return 'error';
    }
    String accessToken;
    if(conexion){
      try{
        await oauth.login();
        accessToken= await oauth.getAccessToken();
      }catch (e){
      }
      //solicitar token como string
      var decodedToken = new JWT.parse(accessToken); //Decodificar token usando libreria corsac jwt
      var correo = decodedToken.getClaim('upn');
      MyApp.token=accessToken;
      final url = Uri.http(ProviderConfig.url,ProviderConfig.path+servicioPath+correo);
      final resp = await http.get(url);
      if (resp.statusCode == HttpStatus.ok) {
        final decodedData = json.decode(resp.body);
        if (decodedData.isNotEmpty) {
          if (decodedData[0]['estado'] == 'AFILIADO') {
            MyApp.correoUsuario = correo;
            return correo;
          } else {
            return 'NA';//print('no afiliado');
          }
        } else {
          return 'NR';//print('no registrado');
        }
      }
    }
    return null;
  }//solicitar inicio de sesion

  logOut(context) {
    MyApp.show=true;
    MyApp.correoUsuario = '';
    oauth.logout();
    Navigator.pushReplacementNamed(context, '/');
  }

  isloged() {
    return oauth.tokenIsValid();
  }
}