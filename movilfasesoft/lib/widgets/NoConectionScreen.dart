import 'package:flutter/material.dart';
import 'package:movilfasesoft/providers/azure_login_provider.dart';

Widget noConectionScreen(context,texto){
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
                    Image(image: AssetImage('assets/icons/fasesoftLogoBarra.png'),width: MediaQuery.of(context).size.width*.8,),
                    Padding(padding: EdgeInsets.only(top: 10.0),),
                    Text('Mobile',style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0
                    ),)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    texto,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0),
                    ),
                  OutlineButton(
                    child: Text('Regresar'),
                    onPressed: (){
                      if(texto == 'El usuario no esta afiliado a Fasesoft' ){ 
                        UserLogin().logOut(context);
                      }
                      Navigator.pushNamed(context,'/');
                    },
                    borderSide: BorderSide(color: Colors.blue,width: 3),
                    textColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0),),
                  Text('Fondo de empleados\n Asesoftware',softWrap: true,textAlign: TextAlign.center,
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