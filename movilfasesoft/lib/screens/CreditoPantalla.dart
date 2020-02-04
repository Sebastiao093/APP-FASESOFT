import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:movilfasesoft/models/Credito.dart';
import 'package:movilfasesoft/widgets/ConexionError.dart';

class CreditoPantalla extends StatefulWidget {
  static const routedname = "/PantallaCreditos";

  @override
  _CreditoPantallaState createState() => _CreditoPantallaState();
}

Future<List<dynamic>> obtenerData(String correo) async {
  String _url = 'sarapdev.eastus.cloudapp.azure.com:7001';
  final urlfin = Uri.http(_url,'fasesoft-web/webresources/servicios/fascreditos/historial/' + correo);
  final response = await http.get(urlfin);

  if (response.statusCode == 200) {
    final decodedData = json.decode(response.body);
    return decodedData;
  } else {
    throw Exception('error');
  }
}

class _CreditoPantallaState extends State<CreditoPantalla> {
  @override
  Widget build(BuildContext context) {
    String usuarioCorreo = ModalRoute.of(context).settings.arguments as String;
    Future<List<dynamic>> userData = obtenerData(usuarioCorreo);
    return Scaffold(
      appBar:  AppBar(
        title: Text('Créditos'),
        centerTitle: true,
        actions: <Widget>[
          Container(child: ImageIcon(AssetImage('assets/icons/fasesoftLogo.png'),size: 100.0,))
        ],
      ),
      body: Center(child: contenido1(userData, context),
      ),
    );
  }

  Widget ElementosCartas(Credito elemento, BuildContext ctx) {
    return LayoutBuilder(
      builder: (ctx, constrains) {
        return Card(
          elevation: 10.0,
          margin: EdgeInsets.symmetric(
            vertical: constrains.maxHeight * 0.1,
            horizontal: constrains.maxWidth * 0.05),
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            width: constrains.maxWidth,
            height: constrains.maxHeight,
            margin: EdgeInsets.symmetric(horizontal: constrains.maxWidth * 0.02, vertical: constrains.maxHeight * 0.05),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: constrains.maxWidth * 0.5,
                      height: constrains.maxHeight * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(elemento.nombretipodecredito,style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(elemento.fechaSolicitud.substring(0, 10))
                        ]),
                    ),
                    Container(
                      width: constrains.maxWidth * 0.3,
                      alignment: Alignment.center,
                      child: RaisedButton(
                        padding: EdgeInsets.all(7.0),
                        elevation: 7.0,
                        child: Text(elemento.estado),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        color: getColor(elemento.estado.toString()),
                        onPressed: () {mostrarAlerta(ctx, elemento);},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget contenido1(Future<List<dynamic>> elementos, BuildContext ctx) {
    return LayoutBuilder(
      builder: (ctx, constrains) {
        return Center(
          child: FutureBuilder<List<dynamic>>(
            future: elementos,
            builder: (context, auxElementos) {
              if (auxElementos.hasData) {
                return  !auxElementos.data.isEmpty?ListView.builder(
                  itemCount: auxElementos.data.length,
                  itemBuilder: (context, index) {var elemento = new Credito.fromJson(auxElementos.data.elementAt(index) as Map<String, dynamic>);
                    return Container(
                      width: constrains.maxWidth,
                      height: constrains.maxHeight * 0.25,
                      child: ElementosCartas(elemento, ctx)
                    );
                  },
                ):Container(
                  height: constrains.maxHeight * 0.5,
                  width: constrains.maxWidth,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.blue,),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                    elevation: 15.0,
                    child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FittedBox(
                            child: Center(
                              child: Text('No tienes Créditos con Fasesoft')
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                );
              } else if (auxElementos.hasError) {
                return Container(
                    height: constrains.maxHeight * 0.5,
                    width: constrains.maxWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blue,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      elevation: 15.0,
                      child: Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FittedBox(
                              child: Center(
                                  child: ConexionError()),
                            ),  
                        ],
                      ),
                    ),
                  )
                );
              }
              return CircularProgressIndicator();
            },
          ),
        );
      },
    );
  }

  Color getColor(elemento) {
    if (elemento == 'REGISTRADO') {
      return Colors.blue;
    } else if (elemento == 'APROBADO') {
      return Colors.green;
    } else if (elemento == 'RECHAZADO') {
      return Colors.red;
    } else if (elemento == 'FINALIZADO') {
      return Colors.grey;
    } else if (elemento == 'CANCELADO') {
      return Colors.green[200];
    } else
      return Colors.black;
  }

  void mostrarAlerta(BuildContext ctx, Credito elemento) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(elemento.nombretipodecredito,style: TextStyle(color: Colors.blue),),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cerrar'),
              onPressed: () {Navigator.of(context).pop();},
            )
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Fecha: ' + elemento.fechaSolicitud.substring(0, 10)),
                ],
              ),
              Divider(color: Colors.blue),
              Container(
                child: Column(children: <Widget>[
                  ListTile(
                    title: Text('Descripción: ' + elemento.descripcion),
                    subtitle: Text('Estado: ' + elemento.estado.toLowerCase()),
                  )
                ]),
              ),
              Divider(color: Colors.blue),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Tasa: ' + elemento.tasaReal.toString()),
                ],
              )
            ],
          )
        );
      }
    );
  }
}