enum TypeEntityEnum {
  client, driver
}

String getTextByTypeEntityEnum(TypeEntityEnum type){
  switch (type) {
    case TypeEntityEnum.client:
      return 'Cliente';
    case TypeEntityEnum.driver:
      return 'Conductor';
  }
  return '';
}