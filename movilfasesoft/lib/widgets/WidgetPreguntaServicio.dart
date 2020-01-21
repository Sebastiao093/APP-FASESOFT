import 'package:flutter/material.dart';
import 'package:movilfasesoft/models/Pregunta.dart';
import 'package:movilfasesoft/models/Respuesta.dart';
import '../main.dart';
class WidgetPreguntaServicio extends StatefulWidget {
  final int idAsamblea;
  final Function obtenerPreguntas;
  final Function obtenerRespuestas;
  final Function enviarRespuestas;
  WidgetPreguntaServicio(this.idAsamblea, this.obtenerPreguntas,
      this.obtenerRespuestas, this.enviarRespuestas);

  @override
  _WidgetPreguntaState createState() => _WidgetPreguntaState();
}

class _WidgetPreguntaState extends State<WidgetPreguntaServicio> {
  Map<int, String> _respuestasMarcadas = Map<int, String>();
  List<Map<String, Object>> _jsonEnvio = List<Map<String, Object>>();
  final _textoIngreso = TextEditingController();

  void _seleccionarRespuesta(int idPregunta, String respuesta) {
    setState(() {
      _respuestasMarcadas[idPregunta] = respuesta;
      _jsonEnvio.add({
        "correo": MyApp.correoUsuario,
        "fkasistencia": 14333,
        "idrespuesta": respuesta,
        "FKVOTACION": "$idPregunta"
      });
    });
  }

  void _submitTexto(int idPregunta, TextEditingController textoIngreso) {
    //final String tituloIngresado = tituloControlador.text;

    setState(() {
      _respuestasMarcadas[idPregunta] = textoIngreso.text;
      _jsonEnvio.add({
        "correo": "cagarzon@asesoftware.com",
        "fkasistencia": 14333,
        "idrespuesta":textoIngreso.text,
        "FKVOTACION": "$idPregunta"
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> _preguntas =
        widget.obtenerPreguntas('${widget.idAsamblea}');
    return imprimirPreguntas(_preguntas);
  }

  Widget imprimirPreguntas(Future<List<dynamic>> preguntas) {
    int _numeroPreguntas;
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
                    height: 500,
                    width: 500,
                    child: ListView.builder(
                      itemCount: auxPreguntas.data.length,
                      itemBuilder: (context, index) {
                        _numeroPreguntas = auxPreguntas.data.length;
                        var preguntaUnitaria = new Pregunta.fromJson(
                            auxPreguntas.data.elementAt(index)
                                as Map<String, dynamic>);

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                              elevation: 30,
                              child: imprimirVotos(preguntaUnitaria, context)),
                        );
                      },
                    ),
                  ),
                  RaisedButton(
                    child: Text(
                      'enviar respuestas',
                      textAlign: TextAlign.center,
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_respuestasMarcadas.length != _numeroPreguntas) 
                      {return;}                     
                      for(var i = 0; i < _jsonEnvio.length; i++) {
                        widget.enviarRespuestas(_jsonEnvio.elementAt(i));
                        //print(_jsonEnvio.elementAt(i));
                      }
                    },
                    disabledColor: Theme.of(context).primaryColorLight,
                    elevation: 20,
                    disabledElevation: 10,
                  )
                ],
              ),
            );
          } else if (auxPreguntas.hasError) {
            return Text('recargue por favor');//Text('${auxPreguntas.error}');
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget imprimirVotos(
    Pregunta preguntaUnit,
    BuildContext ctx,
  ) {
    Future<List<dynamic>> respuestas =
        widget.obtenerRespuestas('${preguntaUnit.id}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          preguntaUnit.pregunta,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 2),
          width: double.infinity,
          height: 200,
          child: FutureBuilder<List<dynamic>>(
            future: respuestas,
            builder: (context, auxrespuestas) {
              if (auxrespuestas.hasData) {
                return ListView.builder(
                  itemCount: auxrespuestas.data.length,
                  itemBuilder: (context, index) {
                    var respuestaUnitaria = new Respuesta.fromJson(
                        auxrespuestas.data.elementAt(index)
                            as Map<String, dynamic>);
                    return mostrarRespuesta(
                        auxrespuestas.data.length == 1,
                        ctx,
                        _respuestasMarcadas,
                        preguntaUnit.id,
                        respuestaUnitaria,
                        _seleccionarRespuesta,
                        _textoIngreso,
                        _submitTexto); //
                  },
                );
              } else if (auxrespuestas.hasError) {
                return Text('${auxrespuestas.error}');
              }
              return CircularProgressIndicator();
            },
          ),
        )
      ],
    );
  }
}

Widget mostrarRespuesta(
    bool tipoRespuesta,
    BuildContext ctx,
    Map<int, String> respuestasMarcadas,
    int idPregunta,
    Respuesta respuestaUnitaria,
    Function seleccionarRespuesta,
    TextEditingController textoIngreso,
    Function submitData) {
  return tipoRespuesta
      ? respuestaAbierta(ctx, textoIngreso, submitData, textoIngreso.text == '',
          respuestaUnitaria, idPregunta)
      : respuestaOpciones(ctx, respuestasMarcadas, idPregunta,
          respuestaUnitaria, seleccionarRespuesta);
}

Widget respuestaOpciones(
    BuildContext ctx,
    Map<int, String> respuestasMarcadas,
    int idPregunta,
    Respuesta respuestaUnitaria,
    Function seleccionarRespuesta) {
  Color colorVal = Colors.white;
  if (respuestasMarcadas[idPregunta] == respuestaUnitaria.id.toString()) {
    colorVal = Theme.of(ctx).primaryColorLight;
  }
  return validacionRespuestasOpciones(respuestasMarcadas[idPregunta] == null,
      idPregunta, respuestaUnitaria, seleccionarRespuesta, colorVal);
}

Widget validacionRespuestasOpciones(bool condicion, int idPregunta,
    Respuesta respuestaUnitaria, Function seleccionarRespuesta, Color color) {
  return condicion
      ? InkWell(
          onTap: () =>
              seleccionarRespuesta(idPregunta, respuestaUnitaria.id.toString()),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(21),
              ),
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                respuestaUnitaria.respuesta,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        )
      : Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
          ),
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 150),
          child: Text(respuestaUnitaria.respuesta,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)));
}

Widget respuestaAbierta(
    BuildContext ctx,
    TextEditingController textoIngreso,
    Function submitData,
    bool condicion,
    Respuesta respuestaUnitaria,
    int idPregunta) {
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
            onSubmitted: (_) => submitData(idPregunta, textoIngreso),
          ),
        )
      : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(ctx).primaryColorLight,
          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 150),
          child: Text(
            textoIngreso.text,
            textAlign: TextAlign.center,
          ),
        );
}
