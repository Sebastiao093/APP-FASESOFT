class Ahorros {
  int aporte;
  String estado;
  String fasAfiliadosCorreo;
  int fasTiposAhoIdTipoAho;
  String fechaInicio;
  String fechaInicioAporte;
  String fechaSolicitud;
  int idAhorro;
  int monto;
  String tipoAhorro;

  Ahorros.fromJson(Map<String, dynamic> data) {
    this.aporte               = data['aporte'];
    this.estado               = data['estado'];
    this.fasAfiliadosCorreo   = data['fasAfiliadosCorreo'];
    this.fasTiposAhoIdTipoAho = data['fasTiposAhoIdTipoAho'];
    this.fechaInicio          = data['fechaInicio'];
    this.fechaInicioAporte    = data['fechaInicioAporte'];
    this.fechaSolicitud       = data['fechaSolicitud'];
    this.idAhorro             = data['idAhorro'];
    this.monto                = data['monto'];
    this.tipoAhorro           = data['tipoAhorro'];
  }
}