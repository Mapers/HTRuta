enum TypeServiceEnum {
  taxi, interprovincial, cargo
}

String getTextByTypeServiceEnum(TypeServiceEnum type){
  switch (type) {
    case TypeServiceEnum.taxi:
      return 'Taxi';
    case TypeServiceEnum.interprovincial:
      return 'Interprovincial';
    case TypeServiceEnum.cargo:
      return 'Carga';
  }
  return '';
}