extension EmailValidationExt on String {
  bool get isEmail => RegExp(
    r'^[a-zA-Z0-9]+([._a-z0-9-]+[a-z0-9])?@[a-z0-9]{2,}([.a-z0-9-]+[a-z0-9])?\.[a-z]{2,8}$',
  ).hasMatch(this);
}
