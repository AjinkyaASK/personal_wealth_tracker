import 'package:intl/intl.dart';

String getFormattedCurrency(double amount) {
  return NumberFormat.currency(
    locale: 'en-In',
    symbol: '₹',
    decimalDigits: 0,
  ).format(amount).toString();
}
