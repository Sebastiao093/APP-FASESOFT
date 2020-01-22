import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majascan/majascan.dart';
import 'package:movilfasesoft/models/infoAsistente.dart';
import 'package:movilfasesoft/providers/info_asistente_providers.dart';

class PantallaQr extends StatefulWidget {
  static const routedname = "/PantallaQr";

  @override
  _PantallaQrState createState() => _PantallaQrState();
  
}

class _PantallaQrState extends State<PantallaQr> {

  String _valorAsistencia = '';
  
  @override
  void initState() { 
    super.initState();
    
    _scanQR();

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Asistencia'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            child: ImageIcon( AssetImage('assets/icons/fasesoftLogo.png'), size: 90.0,)
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Text(_valorAsistencia),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _botonQR(),
    );
  }
  
  Widget _botonQR() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          child: Icon(Icons.filter_center_focus),
          onPressed: _scanQR,
        ),
      ],
    );
  }

  /*Future<List<dynamic>> lectura(){
    //final infoAsistenteProvider = new InfoAsistenteProvider();
    String data = infoAsistenteProvider.getInfoAsistente('asalgado@asesoftware.com');
    return data;
  }*/

  Future<InfoAsistente> cargarInfoAsistente(String correo) async  {
    final infoasistenteprovider = InfoAsistenteProvider();
    InfoAsistente infoAsistente = await infoasistenteprovider.getInfoAsistente(correo);
    print(infoAsistente.estado.toString());
    print(infoAsistente.estado.toString());

    Map<String, Object> mapAsistente = {
      'correo'      : infoAsistente.correo,
      'estado'      : 'SIASI',
      'idAsamblea'  : infoAsistente.idAsamblea,
      'idAsistente' : infoAsistente.idAsistente,
      'idUsuario'   : infoAsistente.idUsuario,
      'nombre'      : infoAsistente.nombre,
      'apellido'    : infoAsistente.apellido,
    };

    enviarCambioEstadoPut(mapAsistente);

    print(infoAsistente.estado.toString());

    return infoAsistente;
  }


  Future _scanQR() async {

    String futureString = '';

    try {
      futureString = await MajaScan.startScan(
        title: 'QR Asistencia', 
        qRCornerColor: Colors.blue,
        qRScannerColor: Colors.deepPurple,
	      flashlightEnable: true
      );
      //cargarInfoAsistente(futureString);
      cargarInfoAsistente(futureString);
      setState(() => this._valorAsistencia = 'Registrado');
    } on PlatformException catch (e) {
      if (e.code == MajaScan.CameraAccessDenied) {
        setState(() => 'El usuario rechazo permisos de uso de cámara');
      } else {
        setState(() => this._valorAsistencia = 'Error desconocido $e');
      }
    } on FormatException {
      setState(() => this._valorAsistencia =
          'nulo, el usuario presionó el botón de volver antes de escanear algo)');
    } catch (e) {
      setState(() => this._valorAsistencia = 'Error desconocido : $e');
    }

    print('Datos obtenidos: $futureString');

    if ( futureString != null) {
      print('Tenemos informacion');
    }
  }

void enviarCambioEstadoPut(Map<String, Object> dato) async {
    String url = "http://sarapdev.eastus.cloudapp.azure.com:7001/fasesoft-web/webresources/servicios/fasasistentes/actualizarEstado";

    var response = await http.put(
      Uri.encodeFull(url),
      body: json.encode(dato),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
  }

}