class Liability {
  final String category;
  final String label;
  final double value;

  Liability({required this.category, required this.label, required this.value});

  factory Liability.fromMap(Map<String, dynamic> map) {
    return Liability(
      category: map['category'] ?? '',
      label: map['label'] ?? '',
      value: double.tryParse(map['value']?.toString() ?? '0') ?? 0,
    );
  }
}
