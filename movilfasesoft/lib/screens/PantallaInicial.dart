import 'package:flutter/material.dart';
import 'package:movilfasesoft/screens/AsistenciaQR.dart';
import 'package:movilfasesoft/screens/ConvenioPantalla.dart';
import 'package:movilfasesoft/screens/CreditoPantalla.dart';
import './Votaciones.dart';

void irVotaciones(BuildContext ctx) {
  Navigator.of(ctx).pushNamed(PantallaVotaciones.routedname);
}

void irCreditos(BuildContext ctx) {
  Navigator.of(ctx).pushNamed(CreditoPantalla.routedname);
}


void irConvenios(BuildContext ctx) {
  Navigator.of(ctx).pushNamed(ConvenioPantalla.routedname);
}

void irQr(BuildContext ctx) {
  Navigator.of(ctx).pushNamed(PantallaQr.routedname);
}

class PantallaInicial extends StatelessWidget {
  static const routedname = "/PantallaInicial";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Inicial'),
      ),
      body: Center(child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Votaciones'),
            onPressed: () => irVotaciones(context),
          ),
          RaisedButton(
            child: Text('Credito'),
            onPressed: () => irCreditos(context),
          ),
          RaisedButton(
            child: Text('Convenios'),
            onPressed: () => irConvenios(context),
          ),
          RaisedButton(
            child: Text('QR'),
            onPressed: () => irQr(context),
          ),
        ],
      )),
    );
  }
}
