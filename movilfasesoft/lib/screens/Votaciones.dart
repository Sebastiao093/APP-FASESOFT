import 'package:flutter/material.dart';
import 'package:movilfasesoft/main.dart';
import 'package:movilfasesoft/models/RespuestaContestadas.dart';
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

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool _preguntasPorVotar = ModalRoute.of(context).settings.arguments;

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
      body: condicionInicial(appBar, _preguntasPorVotar),
    );
  }
}

Widget inicializacionPantalla(
    InfoAsistente auxAsistentes, AppBar appBar, bool preguntasPorVotar) {
  return FutureBuilder<List<dynamic>>(
    future: Votaciones_providers.solicitarRespuestasContestadas(
        auxAsistentes.idAsistente.toString()),
    builder: (context, listaRespuestasContestadasAux) {
      if (listaRespuestasContestadasAux.hasData) {
        List<RespuestasContestadas> listaRespuestas =
            List<RespuestasContestadas>();
        for (var i = 0; i < listaRespuestasContestadasAux.data.length; i++) {
          listaRespuestas.add(RespuestasContestadas.fromJson(
              listaRespuestasContestadasAux.data.elementAt(i)));
        }
        return WidgetPreguntaServicio(
            auxAsistentes.idAsamblea.toString(),
            auxAsistentes.idAsistente,
            appBar,
            Votaciones_providers.solicitarPreguntasPorVotacion(
                auxAsistentes.idAsamblea.toString()),
            listaRespuestas);
      } else if (listaRespuestasContestadasAux.hasError) {
        return mensajeNoInternet(
            'Hay un Problema  \n con la Conexión a internet',context);
      }
      return Center(child: CircularProgressIndicator());
    },
  );
}

Widget condicionInicial(AppBar appBar, bool preguntasPorVotar) {
  Future<InfoAsistente> infoAsistente =
      InfoAsistenteProvider().getInfoAsistente(MyApp.correoUsuario);
  return FutureBuilder<InfoAsistente>(
    future: infoAsistente,
    builder: (context, auxAsistentes) {
      if (auxAsistentes.hasData) {
        return inicializacionPantalla(
            auxAsistentes.data, appBar, preguntasPorVotar);
      } else if (auxAsistentes.hasError) {
        return mensajeNoInternet(' Hay un Problema  \n con la Conexión a internet',context);
      }
      return Center(child: CircularProgressIndicator());
    },
  );
}

Widget mensajeNoInternet(String mensaje, BuildContext context){

  return  Center(
    child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: SafeArea(
                                          child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        elevation: 15.0,
                        child: Padding(
                          padding: EdgeInsets.all(1.0),
                          child:  FittedBox(
                                child: Text(mensaje,textAlign: TextAlign.center,),
                              ),
                        ),
                      ),
                    )),
  );
}