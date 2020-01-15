
List<Map<String, Object>> get preguntasConstantes {
    return [
    { 'id':1, 
      'laPregunta': '¿Presidente del proximo año?',
      'lasRespuestas': [
        {'id':1,'titulo':'opcion1'},{'id':2,'titulo':'opcion2'},{'id':3,'titulo':'opcion3'}
      ]
    },
    {
      'id':2, 
      'laPregunta': '¿Vote para los miembros del consejo?',
      'lasRespuestas': [
        {'id':1,'titulo':'opcionA'},{'id':2,'titulo':'opcionB'},{'id':3,'titulo':'opcionC'}
      ]
    },

    {
      'id':3, 
      'laPregunta': '¿Vote por la cuota minima de aporte del proximo año?',
      'lasRespuestas': [
        {'id':1,'titulo':'opcion A1'},{'id':2,'titulo':'opcion B2'},{'id':3,'titulo':'opcion C3'}
      ]
    },

    {
      'id':4, 
      'laPregunta': '¿ vote por la fecha de votaciones del comite ?',
      'lasRespuestas': [
        {'id':1,'titulo':'opcion buena'},{'id':2,'titulo':'opcion mala'}
      ]
    },

    {
      'id':5, 
      'laPregunta': '¿Vote para segregar miembros?',
      'lasRespuestas': [
        {'id':1,'titulo':'Si'},{'id':2,'titulo':'No'}
      ]
    },

    {
      'id':6, 
      'laPregunta': '¿porque no esta de acuerdo? (Pregunta abierta)',
      'lasRespuestas': [
        {'id':1,'titulo':''}
      ]
    },
   
  ];
  
  }