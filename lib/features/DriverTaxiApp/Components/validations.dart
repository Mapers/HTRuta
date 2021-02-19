class Validations {
  String validateName(String value) {
    if (value.isEmpty) return 'El nombre es obligatorio.';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Por favor ingrese solo caracteres.';
    return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingrese un correo válido';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) return 'Por favor, escriba una contraseña.';
    return null;
  }

  String validateMobile(String value) {
    if (value.length != 9)
      return 'EL numero de celular debe tener 9 dígitos';
    else
      return null;
  }
}
