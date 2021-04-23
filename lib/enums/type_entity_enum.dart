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