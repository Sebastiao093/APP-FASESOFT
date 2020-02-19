import 'package:flutter/material.dart';

Widget conexionError(){
  return Container(
    child: Center(
      child: Column(
        children: <Widget>[
          Icon(Icons.signal_wifi_off, color:Colors.red ,size: 50.0,),
          SizedBox(height: 10.0,),
          Text('Error De Conexión'),
        ],
      ),
    ),
  );
}