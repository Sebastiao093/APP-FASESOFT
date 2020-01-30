import 'package:flutter/material.dart';
import 'package:movilfasesoft/screens/inicial.dart';
import 'mixis/mixis_block_screen.dart';
import 'routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget  with PortraitModeMixin {
  static String correoUsuario='';
  static String token='';
  static bool show=true;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Fasesoft',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blueAccent,
        // canvasColor: Color.fromRGBO(255, 254, 229, 1),
        // fontFamily: 'Raleway',
        // textTheme: ThemeData.light().textTheme.copyWith(
        //         body1: TextStyle(
        //       color: Color.fromRGBO(20, 51, 51, 1),
        //     ),
        //     body2: TextStyle(
        //       color: Color.fromRGBO(20, 51, 51, 1),
        //     ),
        //     title: TextStyle(
        //       fontSize: 24,
        //       fontFamily: 'RobotoCondensed',
        //       fontWeight: FontWeight.bold,
        //     )
        //     ),
      ),
      //home: PantallaCategorias(),
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
