class Asset {
  final String category;
  final String label;
  final double value;

  Asset({required this.category, required this.label, required this.value});

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      category: map['category'] ?? '',
      label: map['label'] ?? '',
      value: double.tryParse(map['value']?.toString() ?? '0') ?? 0,
    );
  }
}
