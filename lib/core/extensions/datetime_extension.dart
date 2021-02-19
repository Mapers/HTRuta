extension DateTimeExtension on DateTime {
  String get format {
    return "${this.year}-${this.month.toString().padLeft(2,'0')}-${this.day.toString().padLeft(2,'0')} ${this.hour.toString()}:${this.minute.toString()}";
  }
  String get ddmmyyyy {
    return "${this.day.toString().padLeft(2,'0')}/${this.month.toString().padLeft(2,'0')}/${this.year}";
  }
  String get mmyyyy {
    return "${this.month.toString().padLeft(2,'0')}/${this.year}";
  }
  String get formatCodeMapping {
    return "${this.year}${this.month.toString().padLeft(2,'0')}${this.day.toString().padLeft(2,'0').padLeft(2, '0')}${this.hour.toString().padLeft(2, '0')}${this.minute.toString().padLeft(2, '0')}";
  }
  String get formatCodeBranch {
    return "${this.year}${this.month.toString().padLeft(2,'0')}${this.day.toString().padLeft(2,'0').padLeft(2, '0')}${this.hour.toString().padLeft(2, '0')}${this.minute.toString().padLeft(2, '0')}";
  }
  String get formatDateday {
    return "${this.day} de ${getMonthName(this.month).toLowerCase()} del ${this.year}";
  }
  String get formatDateMonth {
    return "${getMonthName(this.month)} del ${this.year}";
  }

  String  getMonthName(int month){
    switch(month){
      case 1:
      return 'Enero';
      case 2:
      return 'Febrero';
      case 3:
      return 'Marzo';
      case 4:
      return 'Abril';
      case 5:
      return 'Mayo';
      case 6:
      return 'Junio';
      case 7:
      return 'Julio';
      case 8:
      return 'Agosto';
      case 9:
      return 'Septiembre';
      case 10:
      return 'Octubre';
      case 11:
      return 'Noviembre';
      case 12:
      return 'Diciembre';
    }
    return '-';
  }

}