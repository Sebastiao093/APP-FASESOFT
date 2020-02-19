import 'package:flutter/material.dart';
import 'package:movilfasesoft/models/Asamblea.dart';
import 'package:movilfasesoft/providers/asamblea_providers.dart';
import 'package:movilfasesoft/utils/dateFormat.dart';
import 'package:movilfasesoft/widgets/ConexionError.dart';

class AsambleaPantalla extends StatelessWidget {
 
  static const routedname = "/PantallaAsamblea";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ImageIcon(AssetImage('assets/icons/fasesoftLogoBarra.png'),size: 150.0,
        ),
        centerTitle: true,
      ),
      body: _widgetlstAsambleas(),
    );
  }

  Widget _widgetlstAsambleas() {
    AsambleaProviders asambleaProviders = new AsambleaProviders();
    return FutureBuilder(
      future: asambleaProviders.getAsambleas(),
      builder: (ctx, AsyncSnapshot<List<Asamblea>> snap) {
        if(snap.hasError){
          print(snap.error.toString());
          return Container(
            padding: EdgeInsets.symmetric(vertical:100.0),
            child: conexionError(),
          );
        }
        if (snap.hasData) {
          if (snap.data.length > 0) {
            return _asambleaItem(snap.data[0]);
          } else {
            return Center(
              child: Text('No hay Asambleas Disponibles'),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _asambleaItem(Asamblea item) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blue,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
              ),
              elevation: 45.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                child: Icon(Icons.people,size: 45.0,color: Colors.blue,),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text('ASAMBLEA', style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w800,fontSize: 25.0,)
                                  )
                                ),
                              ),
                            ],
                          ),
                          Divider(color: Colors.blue,),
                          _informacion('Lugar: ', Icons.account_balance,item.nombreLugar),
                          Divider(),
                          _informacion('Dirección: ', Icons.location_on, item.lugar),
                          Divider(),
                          _informacion('Fecha: ', Icons.calendar_today, dateFormat.format(dateConvert.parse(item.fecha))),
                          Divider(),
                          _informacion('Hora: ', Icons.alarm, item.hora),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _informacion(String parametro, IconData icono, String informacion) {
    return Row(
      children: <Widget>[
        Icon(icono, color: Colors.blue,),
        SizedBox(width: 10.0,),
        Expanded(
          child: Container(
            child: ListTile(
              title: Text(parametro),
              subtitle: Text(informacion,textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,)
            ),
          ),
        )
      ],
    );
  }
}