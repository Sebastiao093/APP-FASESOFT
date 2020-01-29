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
  Map<int, int> _respuestasMarcadas = Map<int, int>();

  void _seleccionarRespuesta(int indPregunta, Respuesta respuesta) {
    setState(() {
      _respuestasMarcadas[indPregunta] = respuesta.id;
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
                Text(
                  widget.preguntasAvotar.elementAt(index).pregunta,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Column(
                  children: widget.preguntasAvotar
                      .elementAt(index)
                      .respuestas
                      .map((respuestaUnitaria) {
                    Color colorVal = Colors.white;
                    if (_respuestasMarcadas[
                            widget.preguntasAvotar.elementAt(index).id] ==
                        respuestaUnitaria.id) {
                      colorVal = Colors.red;
                    }
                    return validacionRespuestas(
                        _respuestasMarcadas[
                                widget.preguntasAvotar.elementAt(index).id] ==
                            null,
                        widget.preguntasAvotar.elementAt(index).id,
                        respuestaUnitaria,
                        _seleccionarRespuesta,
                        colorVal);
                  }).toList(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget validacionRespuestas(bool condicion, int index,
    Respuesta respuestaUnitaria, Function seleccionarRespuesta, Color color) {
  return condicion
      ? InkWell(
          onTap: () => seleccionarRespuesta(index, respuestaUnitaria),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 150),
              child: Text(respuestaUnitaria.respuesta)),
        )
      : Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 150),
          child: Text(respuestaUnitaria.respuesta));
}
