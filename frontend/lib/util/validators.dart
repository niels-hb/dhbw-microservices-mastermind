class Validators {
  static String username(String text) {
    if (!RegExp(r"^[A-Za-z0-9\_-]{4,16}$").hasMatch(text)) {
      return 'Zwischen 4 und 16 Buchstaben, Zahlen oder _, -!';
    }

    return null;
  }

  static String email(String text) {
    if (!RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
    ).hasMatch(text)) {
      return 'Ungültige E-Mail Adresse!';
    }

    return null;
  }

  static String password(String text) {
    if (!RegExp(r"^[A-Za-z0-9\_!\$\%\&§@*+]{8,32}$").hasMatch(text)) {
      return 'Zwischen 8 und 32 Buchstaben, Zahlen oder _, -, !, \$, %, &, §, @, *, +, !';
    }

    return null;
  }

  static String pins(String text) {
    int number = int.tryParse(text);

    if (number == null) {
      return 'Keine gültige Zahl!';
    } else if (number < 4 || number > 8) {
      return 'Du musst zwischen 4 und 8 Stellen auswählen!';
    } else if (number == 7) {
      return 'Genau 7 Stellen sind nicht erlaubt!';
    }

    return null;
  }

  static String maxRounds(String text) {
    int number = int.tryParse(text);

    if (number == null) {
      return 'Keine gültige Zahl!';
    } else if (number < 1) {
      return 'Du musst mindestens 1 Versuch auswählen!';
    }

    return null;
  }

  static String gameColorsCount(String text) {
    int number = int.tryParse(text);

    if (number == null) {
      return 'Keine gültige Zahl!';
    } else if (number < 6 || number > 8) {
      return 'Du musst zwischen 6 und 8 Farben auswählen!';
    }

    return null;
  }
}
