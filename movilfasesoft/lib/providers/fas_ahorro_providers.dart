import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/ahorro.dart';

class FasAhorroProviders {
  final String dominio='sarapdev.eastus.cloudapp.azure.com:7001';
  //final String dominio = '173.16.0.25:7001';
  final String path = 'fasesoft-web/webresources/servicios/fasahorros/';
  

  Future<Ahorros> getAhorroPermanente(String correo) async {
 
   
    final String pathAhorros = 'aportespermanentes';
    final uri = Uri.http(dominio, path + pathAhorros, {'correo': correo});
    print(uri);
    final respuestaHttp = await http.get(uri);
    Ahorros ahorro;
    if (respuestaHttp.statusCode == HttpStatus.ok) {
      final data = respuestaHttp.body;
      List list = json.decode(data);

      list.forEach((item) {
        ahorro = Ahorros.fromJson(item);
      });
    } else {
      print('bolsa papeto');
    }

    return ahorro;
  }

  Future<List<Ahorros>> getMovimientosAporte(String correo) async {
   
    final String pathAhorros = 'movimientosAportes';

    final uri = Uri.http(dominio, path + pathAhorros, {'correo': correo});

    final respuestaHttp = await http.get(uri);

    List<Ahorros> mov = [];

    if (respuestaHttp.statusCode == HttpStatus.ok) {
      final data = respuestaHttp.body;

      List listaMovimientos = json.decode(data);

      listaMovimientos.forEach((item) {
        mov.add(Ahorros.fromJson(item));
      });
    } else {
      print('ERROR en respuesta Http');
    }
    return mov;
  }


   Future<String> getDeuda(String correo) async {
   
    final String pathDeuda="fasesoft-web/webresources/servicios/fasafiliados/datosDeudas";

    final uri = Uri.http(dominio, pathDeuda , {'correo': correo});

    final respuestaHttp = await http.get(uri);

      String deuda='0';

    if (respuestaHttp.statusCode == HttpStatus.ok) {
      final data = respuestaHttp.body;
      List listaDeudas = json.decode(data);
      print(uri);
      if(listaDeudas.length>0){
                int deu=0;
                 listaDeudas.forEach(
                   (data) {
                                
                      String estado = data['estado'];
                      try{
                      int saldo =data['saldo'];
                      if('DESEMBOLSADO'.toUpperCase()==estado.toUpperCase()){
                          deu+=saldo;
                      };
                      }catch (ParseException){
                          return '0';
                      }
                      

                 });

                 return deu.toString();

      }else{ 

        return deuda;
      }

      }
      
     else {
      print('ERROR en respuesta Http');
    }
    return deuda;;
  }
}
