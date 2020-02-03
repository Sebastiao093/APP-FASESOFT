import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/models/ahorro.dart';
import 'package:movilfasesoft/providers/providers_config.dart';
import 'package:movilfasesoft/utils/miExcepcion.dart';

class FasAhorroProviders {
  
  final String pathServicio='fasahorros/';

  Future<Ahorros> getAhorroPermanente(String correo) async {
 
   
    final String pathAhorros = 'aportespermanentes';
    final uri = Uri.http(ProviderConfig.url,ProviderConfig.path+pathServicio+ pathAhorros, {'correo': correo});
    
    final respuestaHttp = await http.get(uri);
    Ahorros ahorro;
    if (respuestaHttp.statusCode == HttpStatus.ok) {
      final data = respuestaHttp.body;
      List list = json.decode(data);

      list.forEach((item) {
        ahorro = Ahorros.fromJson(item);
      });
    } else {
      throw new MiException( errorCode: 200);
    }

    return ahorro;
  }

  Future<List<Ahorros>> getMovimientosAporte(String correo) async {
   
    final String pathAhorros = 'movimientosAportes';

    final uri = Uri.http(ProviderConfig.url,ProviderConfig.path+pathServicio+ pathAhorros, {'correo': correo});

    final respuestaHttp = await http.get(uri);

    List<Ahorros> mov = [];

    if (respuestaHttp.statusCode == HttpStatus.ok) {
      final data = respuestaHttp.body;

      List listaMovimientos = json.decode(data);

      listaMovimientos.forEach((item) {
        mov.add(Ahorros.fromJson(item));
        
      });
     
    } else {
     throw new MiException( errorCode: 200);
    }
    return mov;
  }


   Future<String> getDeuda(String correo) async {
   
    final String pathDeuda="fasafiliados/datosDeudas";

    final uri = Uri.http(ProviderConfig.url,ProviderConfig.path+pathDeuda , {'correo': correo});

    final respuestaHttp = await http.get(uri);

      String deuda='0';

    if (respuestaHttp.statusCode == HttpStatus.ok) {
      final data = respuestaHttp.body;
      List listaDeudas = json.decode(data);
      
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
       throw new MiException( errorCode: 200);
    }
   
  }
}
