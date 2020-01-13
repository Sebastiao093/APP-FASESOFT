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
  List<int> respuestasMarcadas = List<int>();
  bool hab = true;

  void _seleccionarRespuesta(Respuesta respuesta) {
     
    setState(() {
      print(respuestasMarcadas);
      this.respuestasMarcadas.add(respuesta.id);
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
                  children:widget.preguntasAvotar
                      .elementAt(index)
                      .respuestas
                      .map((respuestaUnitaria) {
                    return InkWell(
                      onTap: () => _seleccionarRespuesta(respuestaUnitaria),
                      child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Text(respuestaUnitaria.respuesta)),
                    );
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
