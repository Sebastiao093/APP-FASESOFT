import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/ahorro.dart';


class FasAhorroProviders{

  //final String dominio='sarapdev.eastus.cloudapp.azure.com:7001';
  final String dominio = '173.16.0.84:7001';
  final String path='fasesoft-web/webresources/servicios/fasahorros/';



  Future<Ahorros> getAhorroPermanente(String correo) async {

    final String pathAhorros='aportespermanentes';
    final uri=Uri.http(dominio,path+pathAhorros,{'correo':correo});
    print(uri);
    final respuestaHttp =await http.get(uri);
    Ahorros ahorro;
    if(respuestaHttp.statusCode==HttpStatus.ok){
        final data=respuestaHttp.body;
        List list=json.decode(data);

        list.forEach((item){
          ahorro= Ahorros.fromJson(item);
        });
      
    }else{

       print('bolsa papeto');
    }

    return ahorro;


  }







}