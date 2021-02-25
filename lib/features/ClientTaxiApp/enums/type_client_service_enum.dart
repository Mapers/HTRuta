enum TypeDriverService {
  taxi, interprovincial, cargo
}

String getTextByTypeDriverService(TypeDriverService type){
  switch (type) {
    case TypeDriverService.taxi:
      return 'Taxi';
    case TypeDriverService.interprovincial:
      return 'Interprovincial';
    case TypeDriverService.cargo:
      return 'Carga';
  }
  return '';
}