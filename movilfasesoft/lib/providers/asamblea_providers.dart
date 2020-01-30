import 'package:movilfasesoft/models/Asamblea.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:movilfasesoft/providers/providers_config.dart';

class AsambleaProviders {

  final String pathServicio='fasasambleas/asambleactual';


    Future<List<Asamblea>> getAsambleas() async{
    List<Asamblea> asambleas;
    final url= Uri.http(ProviderConfig.url,ProviderConfig.path+pathServicio);
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



