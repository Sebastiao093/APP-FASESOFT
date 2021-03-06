import 'package:flutter/material.dart';
import 'package:movilfasesoft/providers/azure_login_provider.dart';

Widget splashScreen(context){
  return Scaffold(
    body:Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(decoration: BoxDecoration(color: Colors.white10),),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage('assets/icons/fasesoftLogoBarra.png'),width: MediaQuery.of(context).size.width*.8,),
                    Padding(padding: EdgeInsets.only(top: 10.0),),
                    Text('Mobile',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 26.0),)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                 CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(top: 20.0),),
                  OutlineButton(
                    child: Text('Reintentar'),
                    onPressed: (){Navigator.pushNamed(context,'/PantallaInicial');},
                    borderSide: BorderSide(color: Colors.blue,width: 3),
                    textColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  ),
                  Text('Fondo de empleados\n Asesoftware', softWrap: true, textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color:  Colors.black
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    ),
  );
}

login(context) async {
  var result = await UserLogin().azureLogin(context);
  if (UserLogin().isloged() &&
    result != 'error' &&
    result != 'NR' &&
    result != 'NA' &&
    result != null) {
    Navigator.pushReplacementNamed(context, '/loged');
  }
  if (result == 'NA') {
    Navigator.pushReplacementNamed(context, '/noAfiliado');
  }
  if (result == 'NR') {
    Navigator.pushReplacementNamed(context, '/noRegistrado');
  }
  if (result == 'error') {
    Navigator.pushReplacementNamed(context, '/noConexion');
  }
}