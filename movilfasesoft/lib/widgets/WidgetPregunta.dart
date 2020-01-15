import 'package:flutter/material.dart';
import '../models/Respuesta.dart';
import '../models/Pregunta.dart';

class WidgetPregunta extends StatefulWidget {
  final List<Pregunta> preguntasAvotar;
  WidgetPregunta(this.preguntasAvotar);

  @override
  _WidgetPreguntaState createState() => _WidgetPreguntaState();
}

class _WidgetPreguntaState extends State<WidgetPregunta> {
  Map<int, String> _respuestasMarcadas = Map<int, String>();
  final _textoIngreso = TextEditingController();

  void _seleccionarRespuesta(int idPregunta, String respuesta) {
    setState(() {
      _respuestasMarcadas[idPregunta] = respuesta;
    });
  }

  void _submitData(int idPregunta, TextEditingController textoIngreso) {
    //final String tituloIngresado = tituloControlador.text;

    setState(() {
      _respuestasMarcadas[idPregunta] = textoIngreso.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: widget.preguntasAvotar.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.preguntasAvotar.elementAt(index).pregunta,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(
                  children: widget.preguntasAvotar
                      .elementAt(index)
                      .respuestas
                      .map((respuestaUnitaria) {
                    return mostrarRespuesta(
                        widget.preguntasAvotar
                                .elementAt(index)
                                .respuestas
                                .length ==
                            1,
                        context,
                        _respuestasMarcadas,
                        widget.preguntasAvotar.elementAt(index).id,
                        respuestaUnitaria,
                        _seleccionarRespuesta,
                        _textoIngreso,
                        _submitData);
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
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
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 150),
              child: Text(respuestaUnitaria.respuesta)),
        )
      : Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
          ),
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 150),
          child: Text(respuestaUnitaria.respuesta));
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
  ;
}
