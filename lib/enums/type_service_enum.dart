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
String getRouteByTypeServiceEnum(TypeServiceEnum type){
  switch (type) {
    case TypeServiceEnum.taxi:
      return 'assets/image/taxi_option.png';
    case TypeServiceEnum.interprovincial:
      return 'assets/image/suv.png';
    case TypeServiceEnum.cargo:
      return 'assets/image/camion_option.png';
  }
  return '';
}