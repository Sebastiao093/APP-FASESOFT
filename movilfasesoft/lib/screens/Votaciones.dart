import 'package:flutter/material.dart';
import 'package:movilfasesoft/widgets/WidgetPreguntaServicio.dart';
import '../providers/votaciones_providers.dart';

class PantallaVotaciones extends StatefulWidget {
  static const routedname = "/PantallaVotaciones";
  @override
  _PantallaVotacionesState createState() => _PantallaVotacionesState();
}

class _PantallaVotacionesState extends State<PantallaVotaciones> {
  int idAsambleaActual;
  @override
  Widget build(BuildContext context) {
    Votaciones_providers.solicitarAsambleaActual().then((aux) {
      this.idAsambleaActual = aux;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Votaciones'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: WidgetPreguntaServicio(
          idAsambleaActual),
    );
  }

  
}
