import 'package:flutter/material.dart';
import 'package:movilfasesoft/screens/logedIn.dart';
import '../screens/PerfilPantalla.dart';
import '../screens/AsistenciaQR.dart';
import '../screens/ConvenioPantalla.dart';
import '../screens/CreditoPantalla.dart';
import '../screens/Votaciones.dart';
import '../screens/PantallaInicial.dart';

Map <String,WidgetBuilder> getAplicaciones(){
return <String,WidgetBuilder>{
        '/':(ctx)=>PantallaInicial(),
        '/login':(ctx)=> LoginPage(),
        '/loged':(ctx)=> Logedin(),
        PantallaInicial.routedname: (ctx) => PantallaInicial(),
        PantallaQr.routedname:(ctx) => PantallaQr(),
        PantallaVotaciones.routedname:(ctx) => PantallaVotaciones(),
        CreditoPantalla.routedname:(ctx)=>CreditoPantalla(),
        ConvenioPantalla.routedname:(ctx)=>ConvenioPantalla(),
        PerfilPantalla.routedname:(ctx)=>PerfilPantalla() 
      };

}