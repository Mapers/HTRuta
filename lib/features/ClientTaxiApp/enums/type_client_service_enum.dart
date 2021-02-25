enum TypeClientService {
  taxi, interprovincial, cargo
}

String getTextByTypeClientService(TypeClientService type){
  switch (type) {
    case TypeClientService.taxi:
      return 'Taxi';
    case TypeClientService.interprovincial:
      return 'Interprovincial';
    case TypeClientService.cargo:
      return 'Carga';
  }
  return '';
}