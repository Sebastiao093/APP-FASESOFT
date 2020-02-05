import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:majascan/majascan.dart';
import 'package:movilfasesoft/models/infoAsistente.dart';
import 'package:movilfasesoft/providers/info_asistente_providers.dart';
import 'package:movilfasesoft/providers/photoProvider.dart';
import 'package:movilfasesoft/providers/providers_config.dart';

class PantallaQr extends StatefulWidget {
  static const routedname = "/PantallaQr";
  @override
  _PantallaQrState createState() => _PantallaQrState();
}

class _PantallaQrState extends State<PantallaQr> {
  String  _datosObtenidos           = '';
  String  correo                    = '';
  String  estado                    = '';
  dynamic colorContainer            = Colors.white;
  dynamic colorTexto                = Colors.black87;
  bool    _varBloqueoBotonRegistrar = false;
  bool    _varErrorDatos            = false;
  bool    _varErrorConexion         = false;

  @override
  void initState() { 
    super.initState();
    _scanQR(context);
  }

  void redraw(){
    setState(() {
      this.correo                    = '';
      this.estado                    = '';
      this.colorContainer            = Colors.white;
      this.colorTexto                = Colors.black87;
      this._datosObtenidos           = '';
      this._varBloqueoBotonRegistrar = false;
      this._varErrorDatos            = false;
      this._varErrorConexion         = false;
    });         
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Asistencia'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            child: ImageIcon( AssetImage('assets/icons/fasesoftLogo.png'), size: 90.0,)
          )
        ],
      ),
      body:_infoContenido(_datosObtenidos),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _crearBotones(_datosObtenidos),
      bottomNavigationBar: BottomAppBar(child: _titulosBotones(),),
    );
  }

  Widget _infoContenido(String datos){
    if (datos != '') {
      if (this._varErrorDatos == true) {
        return _alertaSinBoton('No se encontraron datos del usuario', Icons.person, Colors.red);
      } else {
        if (this._varErrorConexion == true) {
          return _alertaSinBoton('Error de conexion', Icons.signal_wifi_off,Colors.red); 
        } else {
          return  FutureBuilder(
            future: _cargarInfoUsuario(datos),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return _datalleUsuario(snapshot.data,colorContainer, colorTexto);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }
      }     
    } else {
      return _alertaSinBoton('Sin lectura de QR', Icons.filter_center_focus, Colors.red); 
    }
  }

  Widget _alertaSinBoton(String info, IconData icono, Color colorIcono){
    return AlertDialog(
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
      title: Text('Alerta',textScaleFactor: 1.5,style: TextStyle(color: Colors.blue)),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(color: Colors.white,height: 20.0,),
          Text(info,textScaleFactor: 1.3,),
          Divider(color: Colors.white,height: 50.0,),
          Icon(icono,color: colorIcono, size: 70.0,)
        ],
      ),
    );
  }

  Future<InfoAsistente> _cargarInfoUsuario(String correo) async {
    InfoAsistente infoAsistente = await InfoAsistenteProvider().getInfoAsistente(correo);
    return infoAsistente;
  }

  Widget _titulosBotones(){
    if (_varBloqueoBotonRegistrar == false) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[   
          Text('ScanQR',textScaleFactor: 1.5,),
        ],
      ); 
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[   
          Text('Registrar',textScaleFactor: 1.5,),
          Text('ScanQR',textScaleFactor: 1.5,),
        ],
      ); 
    }
  }

  Widget _crearBotones(String correo){
    if (_varBloqueoBotonRegistrar == false) {
      return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[   
          FloatingActionButton(child: Icon(Icons.filter_center_focus ), onPressed: ()=> _scanQR(context),heroTag: null,),
        ],
      ); 
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[   
          FloatingActionButton(child: Icon(Icons.description,), onPressed: () => _registrar(context,correo),heroTag: null,), 
          FloatingActionButton(child: Icon(Icons.filter_center_focus ), onPressed: ()=> _scanQR(context),heroTag: null,),
        ],
      ); 
    }
  }
  
  Widget _datalleUsuario(InfoAsistente user,Color colorContainer, Color colorTexto){
    return Center(child:ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 20.0),
          child: CircleAvatar(
            child: CircleAvatar(
              child: userPhoto(_datosObtenidos),
              backgroundColor: Colors.white,
              maxRadius: 48.0,
            ),
            backgroundColor: Colors.blue,
            maxRadius: 50.0,
          ),
        ),
        _informacion('Nombre:',Icons.account_circle,user.nombre + ' ' + user.apellido),
        Divider(color: Colors.blue),
        _informacion('Correo:',Icons.email,user.correo),
        Divider(color: Colors.blue),
        _informacion('Identificacion:',Icons.fingerprint,user.identificacion.toString()),
        Divider(color: Colors.blue),
        _informacion('Afiliacion:',Icons.portrait,user.estadoUsuario),
        Divider(color: Colors.blue),
        _estadoRegistro(colorContainer,colorTexto),
        Divider(color: Colors.blue),
      ],
    ));
  }

  Widget _informacion(String parametro,IconData icono,String informacion){ 
    return Row(
      children: <Widget>[
        Icon(icono,color: Colors.blue,),
        SizedBox(width: 10.0,),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(30.0),
            ),
          child:ListTile(
            title: Text(parametro),
            subtitle: Text(informacion,textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,)),
          ),
        )
      ],
    );
  }

  Widget _estadoRegistro(Color colorContainer,Color colorTexto){ 
    return Row(
      children: <Widget>[
        Icon(Icons.person,color: Colors.blue,),
        SizedBox(width: 10.0,),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: colorContainer,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(30.0),
            ),
          child:ListTile(
            title: Text('Registro:',style: TextStyle(color: colorTexto),),
            subtitle: Text(estado,textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold,color: colorTexto),textAlign: TextAlign.left, )),
          ),
        )
      ],
    );
  }
 
  void _alertaConBoton(String info1,String info2, IconData icono,Color color){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contet) {
        return AlertDialog(
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
          title: Text('Alerta',textScaleFactor: 1.5,style: TextStyle(color: Colors.blue)),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(color: Colors.white,height: 20.0,),
              Text(info1,textScaleFactor: 1.3,),
              Divider(color: Colors.white,height: 5.0,),
              Text(info2,textScaleFactor: 1.3,),
              Divider(color: Colors.white,height: 30.0,),
              Icon(icono,color: color, size: 70.0,)
            ],
          ),
          actions: <Widget>[
            Center(
              child:FlatButton(
                shape: StadiumBorder(),
                child: Text('Aceptar',textScaleFactor: 1.2,),
                color: Colors.blue,
                onPressed: () => Navigator.of(context).pop(),
            )),
          ],
        );
      }
    );
  }

  void _alertaCarga(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contet) {
        return AlertDialog(
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
          title: Text('Alerta',textScaleFactor: 1.5,style: TextStyle(color: Colors.blue)),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(color: Colors.white,height: 20.0,),
              _alertaVariable(),
              Divider(color: Colors.white,height: 30.0,)
            ],
          ),
          actions: <Widget>[
            _alertaVariableBoton(),
          ],
        );
      }
    );
  }

  Widget _alertaVariableBoton(){
    return FutureBuilder(
      future: _postConsulta(),
      builder: (ctx,AsyncSnapshot<String> snap){
        if(snap.hasData){
          if(snap.data=='Registro exitoso'){
            return FlatButton(
              shape: StadiumBorder(),
              child: Text('Aceptar',textScaleFactor: 1.2,),
              color: Colors.blue,
              onPressed: () => Navigator.of(context).pop(),
            );
          }else{
            return FlatButton(
              shape: StadiumBorder(),
              child: Text('Aceptar',textScaleFactor: 1.2,),
              color: Colors.blue,
              onPressed: () => Navigator.of(context).pop(),
            );
          }
        }else if(snap.hasError){
          return FlatButton(
            shape: StadiumBorder(),
            child: Text('Aceptar',textScaleFactor: 1.2,),
            color: Colors.blue,
            onPressed: () => Navigator.of(context).pop(),
          );
        }
        else{ 
          return  Divider(color: Colors.white,height: 40.0,);  
        }
      },
    );
  }

  Widget _alertaVariable(){
    return FutureBuilder(
      future: _postConsulta(),
      builder: (ctx,AsyncSnapshot<String> snap){
        if(snap.hasData){
          if(snap.data=='Registro exitoso'){
            return Column(
              children: <Widget>[
                Text(snap.data,textScaleFactor: 1.3,),
                Divider(color: Colors.white,height: 40.0,),
                Icon(Icons.check,color: Colors.green,size: 70,)
              ],
            );  
          }else{
            return Column(
              children: <Widget>[
                Text(snap.data,textScaleFactor: 1.3,),
                Divider(color: Colors.white,height: 40.0,),
                Icon(Icons.error,color: Colors.red,size: 70,)
              ],
            );  
          }
        }else if(snap.hasError){
          return  Column(
            children: <Widget>[
              Text('Error de conexion',textScaleFactor: 1.3,),
              Divider(color: Colors.white,height: 40.0,),
              Icon(Icons.signal_wifi_off,color: Colors.red,size: 70,)
            ],
          );
        }
        else{
          return  Column(
            children: <Widget>[
              Text('Cargando..',textScaleFactor: 1.3,),
              Divider(color: Colors.white,height: 40.0,),
              CircularProgressIndicator()
            ],
          );
        }
      },
    );
  }

  Future<InfoAsistente> _registrarInfoAsistente(String correo) async  {
    InfoAsistente infoAsistente = await InfoAsistenteProvider().getInfoAsistente(correo);
    Map<String, Object> mapAsistente = {
      'apellido'        : infoAsistente.apellido,
      'correo'          : infoAsistente.correo,
      'direccion'       : infoAsistente.direccion,
      'estado'          : 'SIASI',
      'estadoUsuario'   : infoAsistente.estadoUsuario,
      'idAsamblea'      : infoAsistente.idAsamblea,
      'idAsistente'     : infoAsistente.idAsistente,
      'idUsuario'       : infoAsistente.idUsuario,
      'identificacion'  : infoAsistente.identificacion,
      'nombre'          : infoAsistente.nombre,
      'telefono'        : infoAsistente.telefono,
    };
    _enviarCambioEstadoPut(mapAsistente);
    return infoAsistente;
  }

  Future<String> _postConsulta()async {
    await Future.delayed(Duration(seconds: 2));
    InfoAsistente infoAsistente = await InfoAsistenteProvider().getInfoAsistente(correo);
    if ( infoAsistente.estado == 'SIASI') {
      setState(() {
        this.colorContainer=Colors.green;
        this.colorTexto=Colors.white;
        this.colorContainer=Colors.green;
        this.colorTexto=Colors.white;
        this.estado='Asistencia registrada';
        this._varBloqueoBotonRegistrar = false;
      });
      return 'Registro exitoso';
    } else {
      setState(() {
         this._varBloqueoBotonRegistrar = true;
      });
      return 'Registro no efectuado';
    }
  }

  _registrar(BuildContext context, String correo) {
    _registrarInfoAsistente(correo);
    _alertaCarga();
  }

  Future _scanQR(BuildContext context) async {
    redraw();
    String futureString = '';
    try {
        futureString = await MajaScan.startScan(
        title: 'QR Asistencia', 
        titleColor: Colors.white,
        barColor: Colors.blue,
        qRCornerColor: Colors.blue,
        qRScannerColor: Colors.yellow,
	      flashlightEnable: true
      );
      setState(() => this._datosObtenidos = futureString);
    } catch (e) {
      futureString = e.toString();
    }
    InfoAsistenteProvider().getInfoAsistente(futureString).then((aux){
      this.correo= aux.correo;
      if (aux.estado == 'NOASI') {
        setState(() {
          _alertaConBoton('Datos del usuario cargados','¡Exitosamente!', Icons.check, Colors.green);
          this.estado='Asistencia no registrada';
          this.colorContainer=Colors.red;
          this.colorTexto=Colors.white;
          this._varBloqueoBotonRegistrar = true;
        });
      } else {
        if (aux.estado == 'SIASI') {   
          setState(() {
            _alertaConBoton('Usuario ya registrado','', Icons.person, Colors.green);
            this.estado='Asistencia registrada';
            this.colorContainer=Colors.green;
            this.colorTexto=Colors.white;
            this._varBloqueoBotonRegistrar = false;
          });
        }
      }
    }).catchError((e){
      if (e.errorCode == 100) {
        setState(() {
          this._varBloqueoBotonRegistrar = false;
          this._varErrorDatos = true;
        });
      } else {
        setState(() {
          this._varBloqueoBotonRegistrar = false;
          this._varErrorConexion = true;
        });
      }
    });
  }

  void _enviarCambioEstadoPut(Map<String, Object> dato) async {
    String url = "http://"+ProviderConfig.url+"/"+ProviderConfig.path+"fasasistentes/actualizarEstado";
    await http.put(
      Uri.encodeFull(url),
      body: json.encode(dato),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
    ); 
  }
}