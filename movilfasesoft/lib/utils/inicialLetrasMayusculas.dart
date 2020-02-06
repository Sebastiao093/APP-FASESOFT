String mayusIni(String dato){
  List<String> nombreCom =[];
  List<String> nom1 = dato.split(" ");
  for (var item in nom1) {
    String p3 = item.toUpperCase();
    String p  = p3.substring(0,1);
    String p2 = p3.substring(0,1).toLowerCase();
    String p1 = p3.toLowerCase().replaceFirst(RegExp(p2), p);
    nombreCom.add(p1);
  }
  return nombreCom.join(' ');
}