import 'package:flutter/material.dart';
import 'package:movilfasesoft/models/infoAsistente.dart';
import 'package:movilfasesoft/providers/info_asistente_providers.dart';
import 'package:movilfasesoft/widgets/WidgetPreguntaServicio.dart';


class PantallaVotaciones extends StatefulWidget {
  static const routedname = "/PantallaVotaciones";
  @override
  _PantallaVotacionesState createState() => _PantallaVotacionesState();
}

class _PantallaVotacionesState extends State<PantallaVotaciones> {
  String idAsambleaActual;
  int idAsistente;
  bool hayAsamblea=true;

 void redraw(){
     setState(() {});         
  }
  @override
  Widget build(BuildContext context) {

    Future<InfoAsistente> infoAsistente = InfoAsistenteProvider().getInfoAsistente( "cagarzon@asesoftware.com");
    infoAsistente.then((aux){
      this.hayAsamblea =!(aux==null);
      print(hayAsamblea);
      this.idAsambleaActual=aux.idAsamblea.toString();
      this.idAsistente=aux.idAsistente;
    });

    final appBar = AppBar(
          title: Text('Pantalla Votaciones'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed:redraw,
            ),
          ],
        );

    return Scaffold(
        appBar:appBar,
        body:condicionInicial(hayAsamblea,idAsambleaActual,idAsistente),
        );
  }
}

Widget condicionInicial(bool condicion,String id, int idAs){
return condicion? WidgetPreguntaServicio(id,idAs):Text('No hay asambleas para este año');
}