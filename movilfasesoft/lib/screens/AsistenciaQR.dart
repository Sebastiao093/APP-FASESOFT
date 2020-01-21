import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majascan/majascan.dart';

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

  Future _scanQR() async {

    String futureString = '';

    try {
      futureString = await MajaScan.startScan(
        title: 'QR Asistencia', 
        qRCornerColor: Colors.blue,
        qRScannerColor: Colors.deepPurple,
	      flashlightEnable: true
      );
      setState(() => this._valorAsistencia = futureString);
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
}