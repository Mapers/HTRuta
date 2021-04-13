enum TypeEntityEnum {
  passenger, driver
}

String getTextByTypeEntityEnum(TypeEntityEnum type){
  switch (type) {
    case TypeEntityEnum.passenger:
      return 'Pasajero';
    case TypeEntityEnum.driver:
      return 'Conductor';
  }
  return '';
}