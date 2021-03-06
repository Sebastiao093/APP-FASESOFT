class MiException implements Exception{
 int errorCode;
 static final Map<int,String> listErrorCode = {
    100 : 'Cliente no encontrado',
    200 : 'Error Conexion con el servidor'
  };
  MiException({int errorCode}){
    this.errorCode=errorCode;
  }
  String toString() => 'Exception: '+getErrorMsj() + ' ErrorCode :$errorCode';
  int get  getErrorCode => errorCode;
  String  getErrorMsj(){
    if(listErrorCode.containsKey(getErrorCode)){
      return  listErrorCode[getErrorCode];
    }else{
      return 'Error Indefinido';
    }
  }
}