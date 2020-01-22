
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisAsistenteProvider {
  
  void enviarRespuestasPut(Map<String, dynamic> datoAenviar) async {
    String url ="sarapdev.eastus.cloudapp.azure.com:7001/fasesoft-web/webresources/servicios/fasasistentes/actualizarEstado";

    var response = await http.put(
      Uri.encodeFull(url),
      body: json.encode(datoAenviar),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
  }
}

