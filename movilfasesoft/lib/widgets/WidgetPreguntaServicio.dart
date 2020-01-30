import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movilfasesoft/models/Pregunta.dart';
import 'package:movilfasesoft/models/Respuesta.dart';
import 'package:movilfasesoft/models/RespuestaContestadas.dart';
import 'package:movilfasesoft/screens/logedIn.dart';
import '../main.dart';
import '../providers/votaciones_providers.dart';

class WidgetPreguntaServicio extends StatefulWidget {
  final String idAsamblea;
  final int idAsistente;
  final AppBar appBar;
  final Future<List<dynamic>> _preguntas;
  final List<RespuestasContestadas> _respuestasContestadas;

  WidgetPreguntaServicio(this.idAsamblea, this.idAsistente, this.appBar,
      this._preguntas, this._respuestasContestadas);

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
      print('envio ${_jsonEnvio.elementAt(i)}');
    }
    setState(() {
      contesto = true;
    });
    Navigator.of(context).pop();
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

  void totalPreguntas(int totalPreguntas) {
    setState(() {
      _numeroPreguntas = totalPreguntas;
    });
  }

  int retornarNumeroPreguntas() {
    return _numeroPreguntas;
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < widget._respuestasContestadas.length; i++) {
      _respuestasMarcadas[widget._respuestasContestadas
          .elementAt(i)
          .fkVotacion] = widget._respuestasContestadas.elementAt(i).idrespuesta;
    }
    print(_respuestasMarcadas);

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
                        0.85,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: auxPreguntas.data.length,
                      itemBuilder: (context, index) {
                        _numeroPreguntas = auxPreguntas.data.length;
                        var preguntaUnitaria = new Pregunta.fromJson(
                            auxPreguntas.data.elementAt(index)
                                as Map<String, dynamic>);
                        return Container(
                          height: (MediaQuery.of(context).size.height -
                                  widget.appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.4,
                          width: MediaQuery.of(context).size.width,
                          child: imprimirVotos(_numeroPreguntas, index,
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
                        _respuestasMarcadas.length == _numeroPreguntas &&
                            _respuestasMarcadas.length > 0,
                        context,
                        _jsonEnvio,
                        cancelarBoton,
                        contesto),
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

  Widget imprimirVotos(int numTotalPreguntas, int index, Pregunta preguntaUnit,
      BuildContext ctx, int idAsistente) {
    Future<List<dynamic>> respuestas =
        Votaciones_providers.solicitarRespuestasPorPregunta(
            '${preguntaUnit.id}');

    return LayoutBuilder(
      builder: (ctx, constrains) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: constrains.maxHeight*0.05,horizontal: constrains.maxWidth*0.05),
          padding: EdgeInsets.symmetric(vertical: constrains.maxHeight*0.001,horizontal: constrains.maxWidth*0.001),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15*(constrains.maxHeight/constrains.maxWidth)),
          color: Theme.of(context).primaryColor,
          ),
          child: Card(
            elevation: 20,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: constrains.maxHeight * 0.15,
                    width: constrains.maxWidth,
                    child:  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[Container(width: constrains.maxWidth*0.1,
                          child: Text(
                              '${index + 1}/$numTotalPreguntas',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                        ),
                          Container(width: constrains.maxWidth*0.7,
                            child: FittedBox(
                      child:Column(children: partirPalabra(preguntaUnit.pregunta, 7),)),
                          ),
                        ],
                      ),
                  ),
                  Divider(color: Colors.blue),
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
                                height: auxrespuestas.data.length == 1
                                    ? constrains.maxHeight * 0.5
                                    : 0.7 *
                                        (constrains.maxHeight) /
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
            ),
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
      ? respuestaAbierta(
          ctx,
          textoIngreso,
          submitData,
          respuestasMarcadas,
          respuestaUnitaria,
          idPregunta,
          idAsistente)
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
  return LayoutBuilder(
    builder: (ctx, constraints){
      return condicion
      ? InkWell(
          onTap: () => seleccionarRespuesta(
              idPregunta, respuestaUnitaria.id.toString(), idAsistente),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
          ),margin: EdgeInsets.symmetric(vertical: constraints.maxHeight*0.2),
            padding: EdgeInsets.symmetric(vertical: constraints.maxHeight*0.2),
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
            borderRadius: BorderRadius.circular(100),
          ),margin: EdgeInsets.symmetric(vertical: constraints.maxHeight*0.2),
            padding: EdgeInsets.symmetric(vertical: constraints.maxHeight*0.2),
          child: Text(respuestaUnitaria.respuesta,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
        );
    },
  );
}

Widget respuestaAbierta(
    BuildContext ctx,
    TextEditingController textoIngreso,
    Function submitData,
    Map<int,String> respuestasContestadas,
    Respuesta respuestaUnitaria,
    int idPregunta,
    int idAsistente) {
  return respuestasContestadas[idPregunta] == null
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

List<Text> partirPalabra(String pregunta,int palabraPorLinea){

  List<String> listaPalabras = pregunta.split(" ");
  String frasePalabra="";
  int i=0;
  List<Text> listaEnvio=List<Text>();
  for (String palabra in listaPalabras) {
    i++;
  frasePalabra=frasePalabra+" "+palabra;
  if(i==palabraPorLinea ){
    listaEnvio.add(Text(
       frasePalabra,
       textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold),
       ));
       frasePalabra="";
       i=0;
  }
  }
listaEnvio.add(Text(
       frasePalabra,
       textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold),
       ));
       return listaEnvio;

}
