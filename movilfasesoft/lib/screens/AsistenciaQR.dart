import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:majascan/majascan.dart';
import 'package:movilfasesoft/models/infoAsistente.dart';
import 'package:movilfasesoft/providers/info_asistente_providers.dart';
import 'package:movilfasesoft/providers/photoProvider.dart';

class PantallaQr extends StatefulWidget {
  static const routedname = "/PantallaQr";
  @override
  _PantallaQrState createState() => _PantallaQrState();
}

class _PantallaQrState extends State<PantallaQr> {
  String  _datosObtenidos  = '';
  String  correo           = '';
  String  estado           = '';
  dynamic colorContainer   = Colors.white;
  dynamic colorTexto       = Colors.black87;
  bool    _varRegistro     = false;
  bool    _varBloqueoBoton = false;
  bool    _varError        = false;

  @override
  void initState() { 
    super.initState();
    _scanQR(context);
  }

  void redraw(){
    setState(() {
      this.correo           = '';
      this.estado           = '';
      this.colorContainer   = Colors.white;
      this.colorTexto       = Colors.black87;
      this._datosObtenidos  = '';
      this._varRegistro     = false;
      this._varBloqueoBoton = false;
      this._varError        = false;
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
      bottomNavigationBar: BottomAppBar(child: _titulos(),),
    );
  }

  Widget _infoContenido(String datos){
    if (datos != '') {
      print('varError $_varError');
      if (this._varError == true) {
        return AlertDialog(
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
          title: Text('Alerta',textScaleFactor: 1.5,style: TextStyle(color: Colors.blue)),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(color: Colors.white,height: 20.0,),
              Text('No se encontraron datos',textScaleFactor: 1.3,),
              Divider(color: Colors.white,height: 50.0,),
              Icon(Icons.info,color: Colors.red, size: 70.0,)
            ],
          ),
        );
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
    } else {
      return AlertDialog(
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
        title: Text('Alerta',textScaleFactor: 1.5,style: TextStyle(color: Colors.blue)),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Divider(color: Colors.white,height: 20.0,),
            Text('Sin lectura de QR',textScaleFactor: 1.3,),
            Divider(color: Colors.white,height: 50.0,),
            Icon(Icons.info,color: Colors.red, size: 70.0,)
          ],
        ),
      );
    }
  }

  Future<InfoAsistente> _cargarInfoUsuario(String correo) async {
    InfoAsistente infoAsistente = await InfoAsistenteProvider().getInfoAsistente(correo);
    return infoAsistente;
  }

  Widget _titulos(){
    if (_varBloqueoBoton == false) {
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
    if (_varBloqueoBoton == false) {
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
    utf8.encode(user.apellido);
    return Center(child:ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 20.0),
          child: CircleAvatar(
            child: CircleAvatar(
              child: _avatar(),
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
        _informacion('Afiliacion:',Icons.location_on,user.estadoUsuario),
        Divider(color: Colors.blue),
        _estado(colorContainer,colorTexto),
        Divider(color: Colors.blue),
      ],
    ));
  }

  Widget _avatar(){
    return userPhoto(_datosObtenidos);
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

  Widget _estado(Color colorContainer,Color colorTexto){ 
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
 
  void _alerta(String info, IconData icono,Color color){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (contet) {
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
              Icon(icono,color: color, size: 70.0,)
            ],
          ),
          actions: <Widget>[
            FlatButton(
              shape: StadiumBorder(),
              child: Text('Aceptar',textScaleFactor: 0.9,),
              color: Colors.blue,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      }
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
      'telefono'       : infoAsistente.telefono,
    };
    _enviarCambioEstadoPut(mapAsistente);
    return infoAsistente;
  }

  _registrar(BuildContext context, String correo) {
    if (this.correo != '') {
      if (_varRegistro == true) {
        setState(() {
          _alerta('Persona ya registrada', Icons.person, Colors.green);
          this._varBloqueoBoton = false;
        });
      } else {
        _registrarInfoAsistente(correo);
        Future.delayed(Duration(seconds: 3),() async {
          Future<InfoAsistente> infoAsistente = InfoAsistenteProvider().getInfoAsistente(correo);
          await infoAsistente.then((aux){
            if (aux.estado == 'SIASI') {
              setState(() {
                this.colorContainer=Colors.green;
                this.colorTexto=Colors.white;
                this.colorContainer=Colors.green;
                this.colorTexto=Colors.white;
                _alerta('Registro exitoso', Icons.person, Colors.green);
                this._varBloqueoBoton = false;
              });
            } else {
              if (aux.estado == 'NOASI') {
                setState(() {
                  _alerta('Registro no efectuado', Icons.error, Colors.red);
                  this._varBloqueoBoton = true;
                });
              }
             }
           });
        });
      } 
    } else {
      setState(() {
        _alerta('Sin lectura de QR', Icons.info, Colors.red);
        this._varBloqueoBoton = true;
      });
    } 
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
      Future<InfoAsistente> infoAsistente = InfoAsistenteProvider().getInfoAsistente(futureString);
      infoAsistente.then((aux){
        if (futureString == aux.correo){
          _alerta('Datos correctos', Icons.check, Colors.green);
          setState(() {
            this.correo= aux.correo;
            if (aux.estado == 'NOASI') {
              this.estado='No registrado';
              this.colorContainer=Colors.red;
              this.colorTexto=Colors.white;
              this._varBloqueoBoton = true;
            } else {
              if (aux.estado == 'SIASI') {
                this._varRegistro = true;
                this.estado='Registrado';
                this.colorContainer=Colors.green;
                this.colorTexto=Colors.white;
                this._varBloqueoBoton = false;
              }
            }
          });
        }else{
          setState(() {
            this._varBloqueoBoton = false;
            this._varError = true;
          });
        } 
      }).catchError(
        (error){
          setState(() {
            this._varBloqueoBoton = false;
            this._varError = true;
          });
        } 
      );
      setState(() => this._datosObtenidos = futureString);
    } catch (e) {
      futureString = e.toString();
    }
  }

  void _enviarCambioEstadoPut(Map<String, Object> dato) async {
    String url = "http://sarapdev.eastus.cloudapp.azure.com:7001/fasesoft-web/webresources/servicios/fasasistentes/actualizarEstado";
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