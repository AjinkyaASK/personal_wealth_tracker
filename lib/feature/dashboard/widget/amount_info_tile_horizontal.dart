import 'package:flutter/material.dart';
import 'package:personal_wealth_tracker/feature/common/currency_util.dart';

class AmountInfoTileHorizontal extends StatelessWidget {
  const AmountInfoTileHorizontal({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    this.formatNumber = true,
    this.icon,
  });

  final Widget? icon;
  final String title;
  final double amount;
  final Color color;
  final bool formatNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        spacing: 16,
        children: [
          if (icon != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(175),
                borderRadius: BorderRadius.circular(12),
              ),
              child: icon!,
            ),
          Text(title, style: TextStyle(fontSize: 14)),
          Spacer(),
          Text(
            formatNumber
                ? getFormattedCurrencyShort(amount)
                : amount.toStringAsFixed(2),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
