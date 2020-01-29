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
  String  nombre           = '';
  String  apellido         = '';
  String  correo           = '';
  String  identificacion   = '';
  String  estado           = '';
 /*  String  direccion        = '';
  String  telefono         = ''; */
  String  afiliacion       = '';
  String  nombre1          = '';
  String  apellido1        = '';
  String  correo1          = '';
  String  identificacion1  = '';
  String  estado1          = '';
  /* String  direccion1       = '';
  String  telefono1        = ''; */
  String  afiliacion1      = '';
  dynamic colorContainer   = Colors.white;
  dynamic colorTexto       = Colors.black87;
  bool    _varBloqueo      = false;
  bool    _varRegistro     = false;
  bool    _regis           = false;
  bool    _varBloqueoBoton = false;
  
  @override
  void initState() { 
    super.initState();
    
    _scanQR(context);

  }

  void redraw(){
    setState(() {
      this.nombre           = '';
      this.apellido         = '';
      this.correo           = '';
      this.identificacion   = '';
      this.estado           = '';
      /* this.direccion        = '';
      this.telefono         = ''; */
      this.afiliacion       = '';
      this.nombre1          = '';
      this.apellido1        = '';
      this.correo1          = '';
      this.identificacion1  = '';
      this.estado1          = '';
     /*  this.direccion1       = '';
      this.telefono1        = ''; */
      this.afiliacion1      = '';
      this.colorContainer   = Colors.white;
      this.colorTexto       = Colors.black87;
      this._datosObtenidos  = '';
      this._varBloqueo      = false;
      this._varRegistro     = false;
      this._regis           = false;
      this._varBloqueoBoton      = false;
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
      //floatingActionButton: _botonQR(),
      floatingActionButton: _crearBotones(_datosObtenidos),
      bottomNavigationBar: BottomAppBar(child: _titulos(),),
    );
  }

  Widget _infoContenido(String datos){
    if (datos != '') {
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
    } else {
      //_alerta('Lectura de QR Incorrecta', Icons.filter_center_focus, Colors.red);
     
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
          actions: <Widget>[
            FlatButton(
              shape: StadiumBorder(),
              child: Text('Aceptar',textScaleFactor: 0.9,),
              color: Colors.blue,
              onPressed: () => _scanQR(context),
            ),
          ],
        );
    }
  }

  Future<InfoAsistente> _cargarInfoUsuario(String correo) async {

    final infoasistenteprovider = InfoAsistenteProvider();
    InfoAsistente infoAsistente = await infoasistenteprovider.getInfoAsistente(correo);
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
  
  Widget _datalleUsuario2(Color colorContainer, Color colorTexto){
    return Center(child:ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 20.0),
          child: CircleAvatar(
            child: CircleAvatar(
              child: Text(''),
              backgroundColor: Colors.white,
              maxRadius: 48.0,
            ),
            backgroundColor: Colors.blue,
            maxRadius: 50.0,
          ),
        ),
        _informacion('Nombre:',Icons.account_circle,'' + ' ' + ''),
        Divider(color: Colors.blue),
        _informacion('Correo:',Icons.email,''),
        Divider(color: Colors.blue),
        _informacion('Identificacion:',Icons.fingerprint,identificacion),
        Divider(color: Colors.blue),
        /* _informacion('Telefono:',Icons.phone,telefono),
        Divider(color: Colors.blue),
        _informacion('Direccion:',Icons.location_on,direccion), */
        Divider(color: Colors.white),
        _informacion('Afiliacion:',Icons.location_on,afiliacion),
        Divider(color: Colors.white),
        _estado2(colorContainer,colorTexto),
      ],
    ));
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
              child: _avatar(user),
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
       /*  _informacion('Telefono:',Icons.phone,user.telefono.toString()),
        Divider(color: Colors.blue),
        _informacion('Direccion:',Icons.location_on,user.direccion), */
        Divider(color: Colors.white),
        _informacion('Afiliacion:',Icons.location_on,user.estadoUsuario),
        Divider(color: Colors.white),
        _estado(colorContainer,colorTexto),
      ],
    ));
  }

  Widget _avatar(InfoAsistente user){
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
  Widget _estado2(Color colorContainer,Color colorTexto){ 

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
            subtitle: Text('',textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold,color: colorTexto),textAlign: TextAlign.left, )),
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
    final infoasistenteprovider = InfoAsistenteProvider();
    InfoAsistente infoAsistente = await infoasistenteprovider.getInfoAsistente(correo);

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

    if (this._regis == false) {

      if (this.correo != '') {

        if (this._varBloqueo == true) {

          _alerta('Lectura de QR Incorrecta', Icons.filter_center_focus, Colors.red);
           this._varBloqueoBoton = true;
           setState(() {});
        }else {
          if (_varRegistro == true) {
            _alerta('Persona ya registrada', Icons.person, Colors.green);
            this._varBloqueoBoton = false;
            setState(() {});
          } else {

            _registrarInfoAsistente(correo);
            setState(() {});
            Future.delayed(Duration(seconds: 3),() async {

              Future<InfoAsistente> infoAsistente = InfoAsistenteProvider().getInfoAsistente(correo);

              await infoAsistente.then((aux){

                this.estado1=aux.estado;

                setState(() {
                  if (this.estado1 == 'SIASI') {

                    this.colorContainer=Colors.green;
                    this.colorTexto=Colors.white;
                    this.colorContainer=Colors.green;
                    this.colorTexto=Colors.white;
                    _alerta('Registro exitoso', Icons.person, Colors.green);
                    _regis = true;
                    this._varBloqueoBoton = false;
                    setState(() {});
                  } else {
                     if (this.estado1 == 'NOASI') {
                      _alerta('Registro no efectuado', Icons.error, Colors.red);
                      this._varBloqueoBoton = true;
                       setState(() {});
                     }
                   }
                });
               });
            });
          }
        }
      } else {
        _alerta('Sin lectura de QR', Icons.info, Colors.red);
        this._varBloqueoBoton = true;
        setState(() {});
      } 
    }else {
      _alerta('Ya se realizo el registro', Icons.filter_center_focus, Colors.red);
      this._varBloqueoBoton = false;
      setState(() {});
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
        
        /* this.nombre1=aux.nombre;
        this.estado1=aux.estado;
        this.apellido1=aux.apellido;
        this.correo1=aux.correo;
        this.telefono1=aux.telefono.toString();
        this.direccion1=aux.direccion;
        this.afiliacion1=aux.estadoUsuario;
        this.identificacion1=aux.identificacion.toString(); */

        if (futureString == aux.correo) {

          _alerta('Datos correctos', Icons.check, Colors.green);

          setState(() {

            this.nombre=aux.nombre;
            this.apellido=aux.apellido;
            this.correo= aux.correo;
            this.identificacion=aux.identificacion.toString();
            /* this.direccion=direccion1;
            this.telefono=telefono1; */
            this.afiliacion=aux.estadoUsuario;

            if (aux.estado == 'NOASI') {
              setState(() {
                this.estado='No registrado';
                this.colorContainer=Colors.red;
                this.colorTexto=Colors.white;
                this._varBloqueoBoton = true;
                setState(() {});
              });
            } else {
              if (aux.estado == 'SIASI') {
                setState(() {
                  this._varRegistro = true;
                  this.estado='Registrado';
                  this.colorContainer=Colors.green;
                  this.colorTexto=Colors.white;
                  this._varBloqueoBoton = false;
                  setState(() {});
                });
              }
            }
          });
        } 
      }).catchError(
        (error){
          _alerta('Datos Icorrectos', Icons.error, Colors.red);
          this._varBloqueo = true;
          this._varBloqueoBoton = true;
          setState(() {});
        } 
      );
      setState(() => this._datosObtenidos = futureString);
    } catch (e) {
      futureString = e.toString();
    }
  }

void _enviarCambioEstadoPut(Map<String, Object> dato) async {
    String url = "http://sarapdev.eastus.cloudapp.azure.com:7001/fasesoft-web/webresources/servicios/fasasistentes/actualizarEstado";

    //String url = "http://173.16.0.32:7001/fasesoft-web/webresources/servicios/fasasistentes/actualizarEstado";

    var response = await http.put(
      Uri.encodeFull(url),
      body: json.encode(dato),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
    ); 
  }
}