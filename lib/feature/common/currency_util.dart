import 'package:intl/intl.dart';

String getFormattedCurrencyFull(double amount) {
  return NumberFormat.currency(
    locale: 'en-In',
    symbol: '₹',
    decimalDigits: 0,
  ).format(amount).toString();
}

String getFormattedCurrencyShort(double amount) {
  return NumberFormat.compactSimpleCurrency(
    locale: 'en-In',
    decimalDigits: 0,
  ).format(amount).toString();
}
