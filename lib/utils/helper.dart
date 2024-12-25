class Helper {
  static bool isEmail(String em) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(em);
  }

  static bool isPassword(String em) {
    return em.length > 5;
  }

  static bool isPhoneNumber(String em) {
    return (RegExp(r'^[0-9]').hasMatch(em) && em.length >= 8);
  }

  static bool isCardNumber(String em) {
    return (RegExp(r'^[0-9]').hasMatch(em) && em.length >= 16);
  }

  static bool iscvv(String em) {
    return (RegExp(r'^[0-9]').hasMatch(em) && em.length >= 3);
  }

  static String? validateEmail(String? value) {
    if (value != "") {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(value ?? ''))
        return "Please enter a valid email";
      else
        return null;
    } else {
      return "This field is required";
    }
  }

  static String? validateName(String? value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(pattern);
    if (value?.length == 0) {
      return "Please enter name";
    } else if (!regExp.hasMatch(value ?? '')) {
      return "Please enter a valid name";
    }
    return null;
  }

  static String? validateNumber(String? value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "Please enter a number";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter a valid number";
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    String pattern =
        r'^[0-9\s\(\)]*$'; // Allow numbers, spaces, and parentheses
    RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return "Please enter a number";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter a valid number";
    }

    return null;
  }

  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input; // Return empty string if input is empty

    return input[0].toUpperCase() + input.substring(1);
  }

  static String? validateFloat(String? value) {
    // Regular expression pattern for validating floating-point numbers
    String pattern = r'^-?\d+(\.\d+)?$';
    RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return "Please enter a number";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter a valid number";
    }
    return null;
  }

  static String? noValidation(String? value) {
    return null;
  }

  static String? validateEmpty(String? value) {
    if (value == "") {
      return "This field is required";
    } else {
      return null;
    }
  }
}
