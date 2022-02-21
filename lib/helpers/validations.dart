class Validations {
  static String isEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    if(regExp.hasMatch(email)){
      return null;
    }
    return "Invalid email address";
  }

  static String validatePassword(String value) {
    if (value.isEmpty || value.length < 7) {
      return "Password must be at least 7 characters long";
    }
    return null;
  }
}
