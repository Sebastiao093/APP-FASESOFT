import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movilfasesoft/models/Pregunta.dart';
import 'package:movilfasesoft/models/Respuesta.dart';
import 'package:movilfasesoft/screens/logedIn.dart';
import '../main.dart';
import '../providers/votaciones_providers.dart';

class WidgetPreguntaServicio extends StatefulWidget {
  final String idAsamblea;
  final int idAsistente;
  final AppBar appBar;
  final Future<List<dynamic>> _preguntas;

  WidgetPreguntaServicio(
      this.idAsamblea, this.idAsistente, this.appBar, this._preguntas);

  @override
  _WidgetPreguntaState createState() => _WidgetPreguntaState();
}

class _WidgetPreguntaState extends State<WidgetPreguntaServicio> {
  Map<int, String> _respuestasMarcadas = Map<int, String>();
  List<Map<String, Object>> _jsonEnvio = List<Map<String, Object>>();
  Map<String, TextEditingController> _textosDeIngreso =
      Map<String, TextEditingController>();
 
  int _numeroPreguntas=0;

  void _seleccionarRespuesta(int idPregunta, String respuesta, int idAs) {
    
    setState(() {
      _respuestasMarcadas[idPregunta] = respuesta;
      _jsonEnvio.add({
        "correo": MyApp.correoUsuario,
        "fkasistencia": idAs,
        "idrespuesta": respuesta,
        "FKVOTACION": "$idPregunta"
      });
    });
  }

  void cancelarBoton(List<Map<String, Object>> jsonEnvio) {
    for (var i = 0; i < jsonEnvio.length; i++) {
      Votaciones_providers.enviarRespuestasPost(jsonEnvio.elementAt(i));
      //print(_jsonEnvio.elementAt(i));
    }
    setState(() {
      Logedin.boolContesto = true;
    });
  }

  void _submitTexto(
      int idPregunta, TextEditingController textoIngreso, int idAs) {
    //final String tituloIngresado = tituloControlador.text;

    setState(() {
      _respuestasMarcadas[idPregunta] = textoIngreso.text;
      _jsonEnvio.add({
        "correo": MyApp.correoUsuario,
        "fkasistencia": idAs,
        "idrespuesta": textoIngreso.text,
        "FKVOTACION": "$idPregunta"
      });
    });
    
  }

 void totalPreguntas(int totalPreguntas){
    setState(() {
      
    _numeroPreguntas=totalPreguntas;
    });
  }

  int retornarNumeroPreguntas(){
    return _numeroPreguntas;
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
            //Elemento element = new Elemento(auxElementos.data.first as Map<String,Dynamic>);
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: (MediaQuery.of(context).size.height -
                            widget.appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.9,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: auxPreguntas.data.length,
                      itemBuilder: (context, index) {
                       _numeroPreguntas=auxPreguntas.data.length;
                        var preguntaUnitaria = new Pregunta.fromJson(
                            auxPreguntas.data.elementAt(index)
                                as Map<String, dynamic>);
                                print(_respuestasMarcadas.length );
                        return Container(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.1,
                              top: 20),
                          height: (MediaQuery.of(context).size.height -
                                  widget.appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.3,
                          width: MediaQuery.of(context).size.width,
                          child: imprimirVotos(
                              preguntaUnitaria, context, idAsistente),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.height -
                            widget.appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.1,
                    width: MediaQuery.of(context).size.width,
                    child: botonEnvio(
                        _respuestasMarcadas.length == _numeroPreguntas && _respuestasMarcadas.length>0,
                        context,
                        _jsonEnvio,
                        cancelarBoton,
                        Logedin.boolContesto),
                  )
                ],
              ),
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

  Widget imprimirVotos(
      Pregunta preguntaUnit, BuildContext ctx, int idAsistente) {
    Future<List<dynamic>> respuestas =
        Votaciones_providers.solicitarRespuestasPorPregunta(
            '${preguntaUnit.id}');

    return LayoutBuilder(
      builder: (ctx, constrains) {
        return Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: constrains.maxHeight * 0.15,
                width: constrains.maxWidth,
                child: FittedBox(
                  child: Text(
                    preguntaUnit.pregunta,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: respuestas,
                builder: (context, auxrespuestas) {
                  if (auxrespuestas.hasData) {
                    return Container(
                      height: constrains.maxHeight * 0.75,
                      width: constrains.maxWidth,
                      child: ListView.builder(
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
                            height:auxrespuestas.data.length == 1?constrains.maxHeight*0.5:(constrains.maxHeight) /
                                auxrespuestas.data.length,
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
                                idAsistente),
                          ); //
                        },
                      ),
                    );
                  } else if (auxrespuestas.hasError) {
                    return Text('${auxrespuestas.error}');
                  }
                  return CircularProgressIndicator();
                },
              )
            ],
          ),
        );
      },
    );
  }
}

Widget botonEnvio(bool condicion, BuildContext context,
    List<Map<String, Object>> jsonEnvio, Function enviarCancelar, bool cancel) {
      print(condicion);
  return condicion & !cancel
      ? RaisedButton(
          child: Text(
            'enviar respuestas',
            textAlign: TextAlign.center,
          ),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            enviarCancelar(jsonEnvio);
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
              "ya respondio todo",
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
    int idAsistente) {
  return tipoRespuesta
      ? respuestaAbierta(ctx, textoIngreso, submitData, textoIngreso.text == '',
          respuestaUnitaria, idPregunta, idAsistente)
      : respuestaOpciones(ctx, respuestasMarcadas, idPregunta,
          respuestaUnitaria, seleccionarRespuesta, idAsistente);
}

Widget respuestaOpciones(
    BuildContext ctx,
    Map<int, String> respuestasMarcadas,
    int idPregunta,
    Respuesta respuestaUnitaria,
    Function seleccionarRespuesta,
    int idAsistente) {
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
      idAsistente);
}

Widget validacionRespuestasOpciones(
    bool condicion,
    int idPregunta,
    Respuesta respuestaUnitaria,
    Function seleccionarRespuesta,
    Color color,
    int idAsistente) {
  return condicion
      ? InkWell(
          onTap: () => seleccionarRespuesta(
              idPregunta, respuestaUnitaria.id.toString(), idAsistente),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(21),
            ),
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Text(
              respuestaUnitaria.respuesta,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )
      : Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(21),
          ),
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: Text(respuestaUnitaria.respuesta,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
        );
}

Widget respuestaAbierta(
    BuildContext ctx,
    TextEditingController textoIngreso,
    Function submitData,
    bool condicion,
    Respuesta respuestaUnitaria,
    int idPregunta,
    int idAsistente) {
  return condicion
      ? Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'por favor responda',
            ),
            controller: textoIngreso,
            onSubmitted: (_) =>
                submitData(idPregunta, textoIngreso, idAsistente),
          ),
        )
      :  Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(ctx).primaryColorLight,
          ),
          child: Text(
            textoIngreso.text,
            textAlign: TextAlign.center,
          ),
        );

      
}
