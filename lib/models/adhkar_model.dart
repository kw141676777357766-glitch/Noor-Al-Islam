class AdhkarItem {
  final String id;
  final String text;
  final int count;
  final String source;
  final String virtue;
  final String? note;
  final String? hadithGrade;

  const AdhkarItem({
    required this.id,
    required this.text,
    required this.count,
    required this.source,
    required this.virtue,
    this.note,
    this.hadithGrade,
  });

  factory AdhkarItem.fromJson(Map<String, dynamic> json) {
    return AdhkarItem(
      id: json['id'] as String,
      text: json['text'] as String,
      count: json['count'] as int,
      source: json['source'] as String? ?? '',
      virtue: json['virtue'] as String? ?? '',
      note: json['note'] as String?,
      hadithGrade: json['hadithGrade'] as String?,
    );
  }
}

class AdhkarCategory {
  final String id;
  final String title;
  final String description;
  final String icon;
  final List<AdhkarItem> items;

  const AdhkarCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.items,
  });

  factory AdhkarCategory.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    if (rawItems is! List) {
      throw const FormatException(
        'يجب أن يحتوي كل قسم من الأذكار على قائمة items.',
      );
    }

    return AdhkarCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? 'book',
      items: rawItems
          .map(
            (item) => AdhkarItem.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}
