import 'package:flutter/material.dart';
import 'package:movilfasesoft/main.dart';
import 'package:movilfasesoft/models/infoAsistente.dart';
import 'package:movilfasesoft/providers/info_asistente_providers.dart';
import 'package:movilfasesoft/providers/votaciones_providers.dart';
import 'package:movilfasesoft/widgets/WidgetPreguntaServicio.dart';

class PantallaVotaciones extends StatefulWidget {
  static const routedname = "/PantallaVotaciones";
  @override
  _PantallaVotacionesState createState() => _PantallaVotacionesState();
}

class _PantallaVotacionesState extends State<PantallaVotaciones> {
 
  void redraw() {


  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Pantalla Votaciones'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: redraw,
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body:condicionInicial(appBar),
    );
  }
}

Widget condicionInicial( AppBar appBar) {
  Future<InfoAsistente> infoAsistente =
      InfoAsistenteProvider().getInfoAsistente(MyApp.correoUsuario);
  return FutureBuilder<InfoAsistente>(
          future: infoAsistente,
          builder: (context, auxAsistentes) {
            if (auxAsistentes.hasData) {
              //Elemento element = new Elemento(auxElementos.data.first as Map<String,Dynamic>);
              return WidgetPreguntaServicio(
                  auxAsistentes.data.idAsamblea.toString(),
                  auxAsistentes.data.idAsistente,
                  appBar,
                  Votaciones_providers.solicitarPreguntasPorVotacion(
                      auxAsistentes.data.idAsamblea.toString()));
            } else if (auxAsistentes.hasError) {
              return Text('${auxAsistentes.error}');
            }
            return CircularProgressIndicator();
          },
        );
}
