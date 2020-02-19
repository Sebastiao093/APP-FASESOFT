class Asamblea {
  String fecha;
  String hora;
  int idAsamblea;
  String lugar;
  String nombreLugar;

  Asamblea.fromJsonItem(Map<String, dynamic> data) {
    this.fecha       = data['fecha'];
    this.hora        = data['hora'];
    this.idAsamblea  = data['idAsamblea'];
    this.lugar       = data['lugar'];
    this.nombreLugar = data['nombreLugar'];
  }
}