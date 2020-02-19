import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movilfasesoft/models/Pregunta.dart';
import 'package:movilfasesoft/models/Respuesta.dart';
import '../main.dart';
import '../providers/votaciones_providers.dart';

class WidgetPreguntaServicio extends StatefulWidget {
  final String idAsamblea;
  final int idAsistente;
  final AppBar appBar;
  final Future<List<dynamic>> _preguntas;
  final Map<int, String> respuestasMarcadasVal;
  WidgetPreguntaServicio(this.idAsamblea, this.idAsistente, this.appBar,
      this._preguntas, this.respuestasMarcadasVal);

  @override
  _WidgetPreguntaState createState() => _WidgetPreguntaState();
}

class _WidgetPreguntaState extends State<WidgetPreguntaServicio> {
  Map<int, String> _respuestasMarcadas = Map<int, String>();
  List<Map<String, Object>> _jsonEnvio = List<Map<String, Object>>();
  Map<String, TextEditingController> _textosDeIngreso =
      Map<String, TextEditingController>();
  bool contesto = false;
  int _numeroPreguntas = 0;

  void _seleccionarRespuesta(int idPregunta, String respuesta) {
    setState(() {
      _respuestasMarcadas[idPregunta] = respuesta;
    });
  }

  void cancelarBoton(List<Map<String, Object>> jsonEnvio, BuildContext ctx) {
    bool error = true;

    _respuestasMarcadas.forEach((index, respuesta) {
      String respuestaAenviar = "";
      if (respuesta == "1") {
        respuestaAenviar = "SI";
      } else if (respuesta == "2") {
        respuestaAenviar = "NO";
      }

      VotacionesProviders.enviarRespuestasPost({
        "correo": MyApp.correoUsuario,
        "fkasistencia": widget.idAsistente,
        "idrespuesta": respuestaAenviar,
        "FKVOTACION": "$index"
      }).then((aux) {}).catchError((e) {
        if (error) {
          showDialog(
              context: ctx,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog(
                    title: Text('Error de conexión',
                        style: TextStyle(color: Colors.blue)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    titleTextStyle: TextStyle(
                      fontSize: 24,
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.bold,
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('cerrar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                    content: Text(
                        'Las respuestas no se han enviado por problemas de conexión'));
              });
        }
      });
      error = false;
    });

    setState(() {
      contesto = true;
    });
    Navigator.of(context).pop();
  }

  void _submitTexto(int idPregunta, TextEditingController textoIngreso) {
    if (_respuestasMarcadas[idPregunta] == null) {
      setState(() {
        _respuestasMarcadas[idPregunta] = textoIngreso.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return imprimirPreguntas(widget._preguntas, widget.idAsistente);
  }

  Widget imprimirPreguntas(Future<List<dynamic>> preguntas, int idAsistente) {
    return Center(
      child: FutureBuilder<List<dynamic>>(
        future: preguntas,
        builder: (context, auxPreguntas) {
          if (auxPreguntas.hasData) {
            return Column(
              children: <Widget>[
                Container(
                  //height: (MediaQuery.of(context).size.height - widget.appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.85,
                  height: MediaQuery.of(context).size.height -
                      widget.appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      75,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: auxPreguntas.data.length,
                    itemBuilder: (context, index) {
                      _numeroPreguntas = auxPreguntas.data.length;
                      var preguntaUnitaria = new Pregunta.fromJson(
                          auxPreguntas.data.elementAt(index)
                              as Map<String, dynamic>);
                      return Container(
                        //height: (MediaQuery.of(context).size.height - widget.appBar.preferredSize.height -MediaQuery.of(context).padding.top) * 0.4,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: imprimirVotos(_numeroPreguntas, index,
                            preguntaUnitaria, context, idAsistente),
                      );
                    },
                  ),
                ),
                Container(
                  //constraints: BoxConstraints(minHeight: 20,maxHeight:50),
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: botonEnvio(
                      (_respuestasMarcadas.length +
                                  widget.respuestasMarcadasVal.length) ==
                              _numeroPreguntas &&
                          _respuestasMarcadas.length > 0,
                      context,
                      _jsonEnvio,
                      cancelarBoton,
                      contesto),
                )
              ],
            );
          } else if (auxPreguntas.hasError) {
            return Text(
                '${auxPreguntas.error}'); //Text('recargue por favor'); //
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget imprimirVotos(int numTotalPreguntas, int index, Pregunta preguntaUnit,
      BuildContext ctx, int idAsistente) {
    Future<List<dynamic>> respuestas =
        VotacionesProviders.solicitarRespuestasPorPregunta(
            '${preguntaUnit.id}');
    return LayoutBuilder(
      builder: (ctx, constrains) {
        return Container(
          margin: EdgeInsets.symmetric(
              vertical: constrains.maxHeight * 0.05,
              horizontal: constrains.maxWidth * 0.05),
          padding: EdgeInsets.symmetric(
              vertical: constrains.maxHeight * 0.001,
              horizontal: constrains.maxWidth * 0.001),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                15 * (constrains.maxHeight / constrains.maxWidth)),
            color: Theme.of(context).primaryColor,
          ),
          child: Card(
            elevation: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: constrains.maxWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        width: constrains.maxWidth * 0.1,
                        child: Text(
                          '${index + 1}/$numTotalPreguntas',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                          width: constrains.maxWidth * 0.7,
                          child: Text(preguntaUnit.pregunta.toUpperCase(),
                              textScaleFactor: 1,
                              style: TextStyle(fontWeight: FontWeight.bold)))
                    ],
                  ),
                ),
                Divider(
                    height: constrains.maxHeight * 0.05, color: Colors.blue),
                FutureBuilder<List<dynamic>>(
                  future: respuestas,
                  builder: (context, auxrespuestas) {
                    if (auxrespuestas.hasData) {
                      return Expanded(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: auxrespuestas.data.length,
                          itemBuilder: (context, index) {
                            var respuestaUnitaria = new Respuesta.fromJson(
                                auxrespuestas.data.elementAt(index)
                                    as Map<String, dynamic>);
                            if ((auxrespuestas.data.length == 1) &
                                (_textosDeIngreso[preguntaUnit.id.toString()] ==
                                    null)) {
                              TextEditingController textoIngreso =
                                  TextEditingController();
                              _textosDeIngreso[preguntaUnit.id.toString()] =
                                  textoIngreso;
                            }
                            return Container(
                              height: constrains.maxHeight * .2,
                              width: constrains.maxWidth,
                              child: mostrarRespuesta(
                                  auxrespuestas.data.length == 1,
                                  ctx,
                                  _respuestasMarcadas,
                                  preguntaUnit.id,
                                  respuestaUnitaria,
                                  _seleccionarRespuesta,
                                  _textosDeIngreso[preguntaUnit.id.toString()],
                                  _submitTexto,
                                  idAsistente,
                                  widget.respuestasMarcadasVal),
                            ); //
                          },
                        ),
                      );
                    } else if (auxrespuestas.hasError) {
                      return mensajeNoInternet(
                          'Se perdio la conexión de internet', context);
                    }
                    return CircularProgressIndicator();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget botonEnvio(bool condicion, BuildContext context,
    List<Map<String, Object>> jsonEnvio, Function enviarCancelar, bool cancel) {
  return condicion & !cancel
      ? RaisedButton(
          child: Text(
            'Enviar respuestas',
            textAlign: TextAlign.center,
          ),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            enviarCancelar(jsonEnvio, context);
          },
          disabledColor: Theme.of(context).primaryColorLight,
          elevation: 20,
          disabledElevation: 10,
        )
      : !cancel
          ? Text(
              ' Por favor \n responder todas las preguntas',
              textAlign: TextAlign.center,
            )
          : Text(
              "Ya respondió todas las preguntas",
              textAlign: TextAlign.center,
            );
}

Widget mostrarRespuesta(
    bool tipoRespuesta,
    BuildContext ctx,
    Map<int, String> respuestasMarcadas,
    int idPregunta,
    Respuesta respuestaUnitaria,
    Function seleccionarRespuesta,
    TextEditingController textoIngreso,
    Function submitData,
    int idAsistente,
    Map<int, String> respuestasMarcadasval) {
  return tipoRespuesta
      ? respuestaAbierta(ctx, textoIngreso, submitData, respuestasMarcadas,
          respuestaUnitaria, idPregunta, idAsistente)
      : respuestaOpciones(
          ctx,
          respuestasMarcadas,
          idPregunta,
          respuestaUnitaria,
          seleccionarRespuesta,
          idAsistente,
          respuestasMarcadasval);
}

Widget respuestaOpciones(
    BuildContext ctx,
    Map<int, String> respuestasMarcadas,
    int idPregunta,
    Respuesta respuestaUnitaria,
    Function seleccionarRespuesta,
    int idAsistente,
    Map<int, String> respuestasMarcadasval) {
  Color colorVal = Colors.white;
  if (respuestasMarcadas[idPregunta] == respuestaUnitaria.id.toString()) {
    colorVal = Theme.of(ctx).primaryColorLight;
  }
  return validacionRespuestasOpciones(
      respuestasMarcadas[idPregunta] == null,
      idPregunta,
      respuestaUnitaria,
      seleccionarRespuesta,
      colorVal,
      idAsistente,
      respuestasMarcadasval[idPregunta]);
}

Widget validacionRespuestasOpciones(
    bool condicion,
    int idPregunta,
    Respuesta respuestaUnitaria,
    Function seleccionarRespuesta,
    Color color,
    int idAsistente,
    String respuestaGuardada) {
  return respuestaGuardada == null
      ? LayoutBuilder(
          builder: (ctx, constraints) {
            return InkWell(
              onTap: () => seleccionarRespuesta(
                  idPregunta, respuestaUnitaria.id.toString()),
              child: Container(
                decoration: BoxDecoration(
                    color: condicion ? Colors.white : color,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.blue,
                      width: 1.0,
                    )),
                margin: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.2,
                    vertical: constraints.maxHeight * 0.1),
                child: Center(
                    child: Text(' ${respuestaUnitaria.respuesta}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ),
            );
          },
        )
      : LayoutBuilder(
          builder: (ctx, constraints) {
            return Container(
              decoration: BoxDecoration(
                  color: respuestaUnitaria.id ==
                          (respuestaGuardada == 'SI' ? 1 : 2)
                      ? Theme.of(ctx).primaryColorLight
                      : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.0,
                  )),
              margin: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.2,
                  vertical: constraints.maxHeight * 0.1),
              child: Center(
                  child: Text('${respuestaUnitaria.respuesta}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold))),
            );
          },
        );
}

Widget respuestaAbierta(
    BuildContext ctx,
    TextEditingController textoIngreso,
    Function submitData,
    Map<int, String> respuestasContestadas,
    Respuesta respuestaUnitaria,
    int idPregunta,
    int idAsistente) {
  return respuestasContestadas[idPregunta] == null
      ? Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: EdgeInsets.symmetric(vertical: 20),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'por favor responda',
            ),
            controller: textoIngreso,
            onSubmitted: (_) =>
                submitData(idPregunta, textoIngreso),
          ),
        )
      : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(ctx).primaryColorLight,
          ),
          child: Text(
            respuestasContestadas[idPregunta],
            textAlign: TextAlign.center,
          ),
        );
}

Widget mensajeNoInternet(String mensaje, BuildContext context) {
  return SafeArea(
    child: Container(
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
              child: FittedBox(
                child: Text(
                  mensaje,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        )),
  );
}
