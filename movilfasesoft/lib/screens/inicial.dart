import 'package:flutter/material.dart';
import 'package:movilfasesoft/providers/azure_login_provider.dart';
import 'dart:async';
import 'dart:convert';

import 'package:movilfasesoft/widgets/firstScreenWidget.dart';


class PrimeraPantalla extends StatefulWidget {
  static const routedname = "/";
  
  @override
  _PrimeraPantallaState createState() => _PrimeraPantallaState();
}


class _PrimeraPantallaState extends State<PrimeraPantalla> {
  var showLoading=false;
@override
  void initState() {
    showLoading=false;
    super.initState();
  }
  Widget build(BuildContext context) {
    print('hi bitches');
    
    return Scaffold(
      body:Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white10),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        // backgroundColor: Colors.white,
                        // radius: 50.0,
                        image: AssetImage('assets/icons/fasesoftLogoBarra.png'),
                        width: MediaQuery.of(context).size.width*.8,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        'Mobile',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 26.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (showLoading) CircularProgressIndicator(),
                    if(!showLoading)OutlineButton(
                      child: Text('Iniciar Sesion'),onPressed: (){
                        setState(() {
                          print('its me');
                           showLoading= true;
                           login(context);
                        });
                        
                      
                      },
                       
                      borderSide: BorderSide(color: Colors.blue,width: 3),
                      textColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    if(showLoading)OutlineButton(
                      child: Text('Reintentar'),onPressed: (){
                        setState(() {
                          print('its me again');
                           showLoading= false;
                        });
                      
                      },
                       
                      borderSide: BorderSide(color: Colors.blue,width: 3),
                      textColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      'Fondo de empleados\n Asesoftware',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color:  Colors.black),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ) 
      ,);
  }
}

  login(context) async {
      var result = await UserLogin().azureLogin(context);
      if (UserLogin().isloged() &&
          result != 'error' &&
          result != 'NR' &&
          result != 'NA' &&
          result!=null) {
          Navigator.pushReplacementNamed(context, '/loged');
      }
      if (result == 'NA') {
      Navigator.pushNamed(context, '/noAfiliado');
      }
      if (result == 'NR') {
      Navigator.pushNamed(context, '/noRegistrado');
      }
      if (result == 'error') {
      Navigator.pushNamed(context, '/noConexion');
      }
  }
