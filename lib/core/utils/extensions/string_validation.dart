extension StringValidationExtension on String {
  bool get isEmailAddress {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(this);
  }

  bool get isPhone {
    if(length != 9) return false;
    String p = r'^[0-9]+$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(this);
  }

  bool get isSecurePassword {
    if(trim().length < 8) return false;
    String p = r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(this);
  }
  bool get isAlphanumeric {
    String p = r'^[a-zA-Z0-9&%=]+$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(this);
  }

  bool get isNumeric {
    if(this == null) {
      return false;
    }
    return double.tryParse(this) != null;
  }

  bool get isNamePeople {
    String p = r"^[A-Za-z ']+$";
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(this);
  }
  bool get isNameEnterprise {
    String p = r"^[A-Za-z '&0-9]+$";
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(this);
  }

  bool get isRucNumber {
    int ruc = int.parse(this);
    if (!(ruc >= 0e10 && ruc < 11e9 || ruc >= 15e9 && ruc < 18e9 || ruc >= 2e10 && ruc < 21e9)){
      return false;
    }
    double suma = (ruc % 10 < 2) ? -1 : 0;
    for (int i = 0; i < 11; i++ , ruc = (ruc/10).truncate()){
      suma += (ruc % 10) * (i % 7 + (i / 7).truncate() + 1);
    }
    return suma % 11 == 0;
  }

}