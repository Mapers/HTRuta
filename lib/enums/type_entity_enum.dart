enum TypeEntityEnum {
  passenger, driver
}

TypeEntityEnum getTypeEntityEnumByString(String type){
  switch (type) {
    case 'PASSENGER':
      return TypeEntityEnum.passenger;
    case 'DRIVER':
      return TypeEntityEnum.driver;
  }
  return null;
}

String getTypeEntity(TypeEntityEnum type){
  switch (type) {
    case TypeEntityEnum.passenger:
      return 'PASSENGER';
    case TypeEntityEnum.driver:
      return 'DRIVER';
  }
  return null;
}