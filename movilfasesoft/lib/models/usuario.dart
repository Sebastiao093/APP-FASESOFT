class UsuariosFromAres{

  List<UsuarioAres>  usuarios= List();

  UsuariosFromAres.fromList(List<dynamic> listUsuariosFromJson){
    
      listUsuariosFromJson.forEach((usuario){
        
        usuarios.add(UsuarioAres.fromJson(usuario));

      });

  }


}


class UsuarioAres {
  String apellido=' ';
  String ciudad=' ';
  String correo=' ';
  String cuentaBancaria=' ';
  String direccion=' ';
  String expedicion=' ';
  String identificacion=' ';
  String nombre=' ';
  String telefono=' ';
  String tipoId=' ';
  int totalOtrosAhorros=0;

  UsuarioAres({
    this.apellido,
    this.ciudad,
    this.correo,
    this.cuentaBancaria,
    this.direccion,
    this.expedicion,
    this.identificacion,
    this.nombre,
    this.telefono,
    this.tipoId,
    this.totalOtrosAhorros,
  });
  String get nombreusuario{
    return nombre;
  }

  UsuarioAres.fromJson(Map<String,dynamic> json){
    this.apellido          =json['apellido'];
    this.ciudad            =json['ciudad'];
    this.correo            =json['correo'];
    this.cuentaBancaria    =json['cuentaBancaria'];
    this.direccion         =json['direccion'];
    this.expedicion        =json['expedicion'];
    this.identificacion    =json['identificacion'].toString();
    this.nombre            =json['nombre'];
    this.telefono          =json['telefono'].toString();
    this.tipoId            =json['tipoId'];
    this.totalOtrosAhorros =json['totalOtrosAhorros'];
  }



}