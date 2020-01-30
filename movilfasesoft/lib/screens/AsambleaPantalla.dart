import 'package:flutter/material.dart';
import 'package:movilfasesoft/models/Asamblea.dart';
import 'package:movilfasesoft/providers/asamblea_providers.dart';
import 'package:intl/intl.dart';


class AsambleaPantalla extends StatelessWidget {
 DateFormat dateConvert = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
 DateFormat dateFormat = DateFormat("yyyy MMMM dd"); 

 static const routedname = "/PantallaAsamblea";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Asambleas'),
          centerTitle: true,
          actions: <Widget>[
            Container(
                child: ImageIcon(
              AssetImage('assets/icons/fasesoftLogo.png'),
              size: 100.0,
            ))
          ],
        ),
      
      body: _WidgetlstAsambleas(),
          );
        }
      
      Widget _WidgetlstAsambleas() {
          AsambleaProviders asambleaProviders=new AsambleaProviders();
        return FutureBuilder(
          future: asambleaProviders.getAsambleas(),
          builder: (ctx,AsyncSnapshot<List<Asamblea>> snap){
              if(snap.hasData){
                String data='pailas';
                if(snap.data.length>0){
               
                  return _listItems(snap.data);
                }else{
                  return  Center(
                      child: Text(
                        'No hay Asableas Disponibles' 
                      ),
                    );
                }
                 
              }else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
          },

        );
      }


      Widget _listItems(List<Asamblea> asamblea){
          return ListView.builder(
            itemCount:asamblea.length,
            itemBuilder: (ctx,posicion){
                return _asambleaItem(asamblea[posicion]);
            },
          );
      }


      Widget _asambleaItem (Asamblea item){
         String fechaFormater;
        try{
        DateTime fecha= dateConvert.parse(item.fecha);
        
        fechaFormater=dateFormat.format(fecha);
        }on FormatException{
              fechaFormater=item.fecha;
        }
          
          return Container(
              child: Column(
                children: <Widget>[
                  Card(
                    child: Column(
                      children: <Widget>[
                           ListTile(    
                     leading: Icon(Icons.account_balance, color: Colors.blue,),
                     title: Text(
                        item.nombreLugar,
                        overflow: TextOverflow.ellipsis,
                     ),
                     subtitle: Text(item.lugar,
                     overflow: TextOverflow.ellipsis),
                   ),
                          Container(
                        child:
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                              Text(
                            'Fecha: ',
                            style: TextStyle( color: Colors.blue, fontSize: 15 , fontWeight: FontWeight.normal ),
                            overflow: TextOverflow.ellipsis
                          ),Text(
                            fechaFormater+" ",
                            style: TextStyle( color: Colors.black, fontSize: 15 , fontWeight: FontWeight.bold ),
                            overflow: TextOverflow.ellipsis
                          ),Text(
                            'Hora: ',
                            style: TextStyle( color: Colors.blue, fontSize: 15 , fontWeight: FontWeight.normal ),
                            overflow: TextOverflow.ellipsis
                          ),Text(
                            item.hora,
                            style: TextStyle( color: Colors.black, fontSize: 15 , fontWeight: FontWeight.bold ),
                            overflow: TextOverflow.ellipsis
                          ),
                          ],
                        )
                        ),
                    SizedBox( height: 10.0,)
                      ],
                    ),
                  ),

                ],

              ),

          );

      }

 


}