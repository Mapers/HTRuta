enum TypeServiceDriver {
  taxi, interprovincial, cargo
}

String getTextByTypeServiceDriver(TypeServiceDriver type){
  switch (type) {
    case TypeServiceDriver.taxi:
      return 'Taxi';
    case TypeServiceDriver.interprovincial:
      return 'Interprovincial';
    case TypeServiceDriver.cargo:
      return 'Carga';
  }
  return '';
}