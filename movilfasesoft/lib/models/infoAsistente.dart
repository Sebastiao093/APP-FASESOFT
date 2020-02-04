class InfoAsistente {
  String apellido;
  String correo;
  String direccion;
  String estado;
  String estadoUsuario;
  int idAsamblea;
  int idAsistente;
  int idUsuario;
  int identificacion;
  String nombre;
  int telefono;

  InfoAsistente({
    this.apellido,
    this.correo,
    this.direccion,
    this.estado,
    this.estadoUsuario,
    this.idAsamblea,
    this.idAsistente,
    this.idUsuario,
    this.identificacion,
    this.nombre,
    this.telefono,
  });

  factory InfoAsistente.fromJson( Map<String, dynamic> json){
    return InfoAsistente(
      apellido        : json['apellido'],
      correo          : json['correo'],
      direccion       : json['direccion'],
      estado          : json['estado'],
      estadoUsuario   : json['estadoUsuario'],
      idAsamblea      : json['idAsamblea'],
      idAsistente     : json['idAsistente'],
      idUsuario       : json['idUsuario'],
      identificacion  : json['identificacion'],
      nombre          : json['nombre'],
      telefono        : json['telefono'],
    );
  }
}