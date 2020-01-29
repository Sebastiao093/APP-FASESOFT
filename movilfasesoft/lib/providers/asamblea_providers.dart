import 'package:movilfasesoft/models/Asamblea.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AsambleaProviders {
  //final String _url='173.16.0.25:7001';
  final String _url='sarapdev.eastus.cloudapp.azure.com:7001';
  final String path='fasesoft-web/webresources/servicios/fasasambleas/asambleactual';
  //String _url = '173.16.0.84:7001';


    Future<List<Asamblea>> getAsambleas() async{
    List<Asamblea> asambleas;
    final url= Uri.http(_url,path);
    print(url);
    final resp = await http.get(url);
    
    if (resp.statusCode==HttpStatus.ok){
      final List<dynamic> decodedData= json.decode(resp.body);
       asambleas=List();
    decodedData.forEach((item){
        asambleas.add(Asamblea.fromJsonItem(item));
    });

   }else{
       print('error en http');
   }

    return asambleas;

 
  }


}



