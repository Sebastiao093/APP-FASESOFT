import 'package:flutter/material.dart';
import 'package:movilfasesoft/main.dart';
import 'package:movilfasesoft/models/infoAsistente.dart';
import 'package:movilfasesoft/providers/info_asistente_providers.dart';
import 'package:movilfasesoft/widgets/WidgetPreguntaServicio.dart';
import '../providers/votaciones_providers.dart';

class PantallaVotaciones extends StatefulWidget {
  static const routedname = "/PantallaVotaciones"; 
  @override
  _PantallaVotacionesState createState() => _PantallaVotacionesState();
}

class _PantallaVotacionesState extends State<PantallaVotaciones> {
  String idAsambleaActual;
  bool hayAsamblea=true;
  @override
  Widget build(BuildContext context) {

    Future<InfoAsistente> infoAsistente = InfoAsistenteProvider().getInfoAsistente( "cagarzon@asesoftware.com");
    infoAsistente.then((aux){
      this.hayAsamblea =!(aux==null);
      print(hayAsamblea);
      this.idAsambleaActual=aux.idAsamblea.toString();
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
        body:condicionInicial(hayAsamblea,idAsambleaActual),
        );
  }
}

Widget condicionInicial(bool condicion,String id){
return condicion? WidgetPreguntaServicio(id):Text('No hay asambleas para este año');
}