import 'package:flutter/material.dart';
import 'package:majascan/majascan.dart';

class PantallaQr extends StatelessWidget {
  static const routedname = "/PantallaQr";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Asistencia'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            child: ImageIcon( AssetImage('assets/icons/fasesoftLogo.png'), size: 100.0,)
          )
        ],
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

  _scanQR() async {

    String futureString ='';

    try {
      futureString = await MajaScan.startScan(
        title: 'QR Asistencia', 
        qRCornerColor: Colors.blue,
        qRScannerColor: Colors.deepPurple,
	      flashlightEnable: true
    );
    } catch (e) {
      futureString = e.toString();
    }

    print('Datos obtenidos: $futureString');

    if ( futureString != null) {
      print('Tenemos informacion');
    }
    print('Datos');
  }
}