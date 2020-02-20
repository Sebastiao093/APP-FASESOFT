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
      list.forEach((item) {ahorro = Ahorros.fromJson(item);});
      int monto=await ahorrosTotales(correo);
      ahorro.monto=monto;
     
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

   Future<int> ahorrosTotales(String correo) async {
    final String pathAhorros="fasafiliados/datosAhroros";
    final uri = Uri.http(ProviderConfig.url,ProviderConfig.path+pathAhorros , {'correo': correo});
    final respuestaHttp = await http.get(uri);
     if (respuestaHttp.statusCode == HttpStatus.ok) {
         final data = respuestaHttp.body;
         List listaAhorrosPermaYvol = json.decode(data);
        if(listaAhorrosPermaYvol.length>0){
        int monto=0;
        listaAhorrosPermaYvol.forEach((item){        
         try{
             monto +=item['monto'];
          }catch (ParseException){

          }
        });
        return monto;
      }else{
        return 0;
      } 
     }else{
          throw new MiException( errorCode: 200);
     }
    
  }
  
  Future<String> getDeuda(String correo) async {
    int deuda=0;
    final String pathDeuda="fasafiliados/datosDeudas";
    final uri = Uri.http(ProviderConfig.url,ProviderConfig.path+pathDeuda , {'correo': correo});
    final respuestaHttp = await http.get(uri);
    if (respuestaHttp.statusCode == HttpStatus.ok) {
      final data = respuestaHttp.body;
      List listaDeudas = json.decode(data);
      if(listaDeudas.length>0){
        int deu=0;
        listaDeudas.forEach((data){        
          String estado = data['estado'];
          try{
            int saldo =data['saldo'];
            if('DESEMBOLSADO'.toUpperCase()==estado.toUpperCase()){
              deu+=saldo;
            }
            deuda=deu;
          }catch (ParseException){
          }
        });
      }
    }else {
      throw new MiException( errorCode: 200);
    }

    final String pathDeudaCon="fasafiliados/datosDeudasCon";
    final uriCon = Uri.http(ProviderConfig.url,ProviderConfig.path+pathDeudaCon , {'correo': correo});
    final respuestaConHttp = await http.get(uriCon);
    if (respuestaConHttp.statusCode == HttpStatus.ok) {
      final dataCon = respuestaConHttp.body;
      List listaDeudasCon = json.decode(dataCon);
      if(listaDeudasCon.length>0){
        int deuCon=0;
        listaDeudasCon.forEach((dataCon){        
          String estado = dataCon['estado'];
          try{
            int saldo =dataCon['saldo'];
            if('ACTIVO'.toUpperCase()==estado.toUpperCase()){
              deuCon+=saldo;
            }
            deuda+=deuCon;
          }catch (ParseException){
          }
        });
      }
    }else {
      throw new MiException( errorCode: 200);
    }
    if (deuda != 0) {
      return deuda.toString();
    } else {
      deuda = 0;
      return deuda.toString();
    }
  }
}