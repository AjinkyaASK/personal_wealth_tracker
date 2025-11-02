import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
