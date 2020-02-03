import 'package:flutter/material.dart';
import 'package:movilfasesoft/screens/AsambleaPantalla.dart';
import 'package:movilfasesoft/screens/codigoQr.dart';
import 'package:movilfasesoft/screens/inicial.dart';
import 'package:movilfasesoft/screens/logedIn.dart';
import 'package:movilfasesoft/screens/pantallasInicio.dart';
import 'package:movilfasesoft/screens/PantallaWeb.dart';
import '../screens/PerfilPantalla.dart';
import '../screens/AsistenciaQR.dart';
import '../screens/ConvenioPantalla.dart';
import '../screens/CreditoPantalla.dart';
import '../screens/Votaciones.dart';


Map <String,WidgetBuilder> getAplicaciones(){
return <String,WidgetBuilder>{
        PrimeraPantalla.routedname:(ctx)=> PrimeraPantalla(),
        Logedin.routedname:(ctx)=> Logedin(),
        CodigoQR.routedname:(ctx)=> CodigoQR(),
        PantallaNoAfiliado.routedname:(ctx)=>PantallaNoAfiliado(),
        PantallaSinConexion.routedname:(ctx)=>PantallaSinConexion(),
        PantallaNoRegistrado.routedname:(ctx)=>PantallaNoRegistrado(),
        PantallaQr.routedname:(ctx) => PantallaQr(),
        PantallaVotaciones.routedname:(ctx) => PantallaVotaciones(),
        CreditoPantalla.routedname:(ctx)=>CreditoPantalla(),
        ConvenioPantalla.routedname:(ctx)=>ConvenioPantalla(),
        PerfilPantalla.routedname:(ctx)=>PerfilPantalla(),
        AsambleaPantalla.routedname: (ctx)=>AsambleaPantalla(),
        PantallaWeb.routedname: (ctx)=>PantallaWeb()
      };

}