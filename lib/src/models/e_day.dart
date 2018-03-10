enum EDay {
  wednesday, thursday, friday
}

class EDayAsString {
  static asString(EDay day) {
    return day.toString().substring(day.toString().indexOf('.')+1);
  }
}