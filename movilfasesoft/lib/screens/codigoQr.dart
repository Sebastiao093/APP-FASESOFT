import 'package:flutter/material.dart';
import 'package:movilfasesoft/main.dart';
import 'package:qr_flutter/qr_flutter.dart';



class CodigoQR extends StatelessWidget {
 static const routedname='/qr';
@override
  Widget build(BuildContext context){
    return Scaffold(
            appBar: AppBar(
              title: ImageIcon(
                AssetImage('assets/icons/fasesoftLogoBarra.png'),
                size: 150.0,
              ),
              centerTitle: true,
            ),
            
            body: Center(
              child:  QrImage(
                data: MyApp.correoUsuario,
                version: QrVersions.auto,
                gapless:true,
                size: 350.0,
                embeddedImage: AssetImage('assets/icons/fasesoftLogo.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                //size: Size(450/5, 450/5),
                color: Colors.grey),
                //foregroundColor: Colors.blueAccent,
              
                     ),
            
            ),
          );


  }
}