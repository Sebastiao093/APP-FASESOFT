import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:corsac_jwt/corsac_jwt.dart';





class UserLogin{

    
    static Config config = new Config(
        "bf208dcb-97e8-4d43-bd72-323680bef25c",//tenand id
        "19d6b921-44b0-42df-946f-d14bf3392cbf",//client id
        "https://login.live.com/oauth20_desktop.srf",
        "https://login.live.com/oauth20_desktop.srf"); //URI
      
    final AadOAuth oauth = AadOAuth(config);//Configuracion de la instancia para AZURE ACTIVE DIRECTORY

      Future<String> azureLogin(context) async {
           
      
          final h =MediaQuery.of(context).size.height;
          final w=MediaQuery.of(context).size.width;
            oauth.setWebViewScreenSize(Rect.fromCenter(center: Offset(w/2,h/2),height: h,width: w));
      
            await oauth.login(); //solicitar inicio de sesion

            String accessToken = await oauth.getAccessToken();//solicitar token como string
            var decodedToken = new JWT.parse(accessToken);//Decodificar token usando libreria corsac jwt
            print(decodedToken.getClaim('upn'));//solicitar el claim 'upn' que es el id de correo en este caso.
            return decodedToken.getClaim('upn');
            
        }
logOut(context){

  oauth.logout();
  Navigator.pushReplacementNamed(context,'/');

}

isloged(){
  return oauth.tokenIsValid();
}

// checkConection()async{
//   var connectivityResult = await (Connectivity().checkConnectivity());
//   if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi ){
//     return true;
//   } else {
//     print('sininternet');
//   return false;
//   }
// }
}