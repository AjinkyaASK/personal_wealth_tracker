import 'package:flutter/material.dart';
import 'package:personal_wealth_tracker/feature/common/currency_util.dart';

class AmountInfoTile extends StatelessWidget {
  const AmountInfoTile({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
  });

  final String title;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(getFormattedCurrency(amount)),
          ],
        ),
      ),
    );
  }
}
