import 'package:flutter/material.dart';
import 'package:movilfasesoft/screens/inicial.dart';
import 'mixis/mixis_block_screen.dart';
import 'routes/routes.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget  with PortraitModeMixin {
  static String correoUsuario='';
  static String token='';
  static bool show=true;
  
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("es_ES", null);
    super.build(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Fasesoft',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blueAccent,
      ),
      initialRoute: '/',
      routes: getAplicaciones(),
      onGenerateRoute: (settings){
        return MaterialPageRoute(
          builder: (ctx) => PrimeraPantalla()
        );
      },
      onUnknownRoute: (settings){
        return MaterialPageRoute(
          builder: (ctx) => PrimeraPantalla()
        );
      },
    );
  }
}