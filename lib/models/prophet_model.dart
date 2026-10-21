/// نموذج بيانات النبي.
///
/// هذا الملف مسؤول فقط عن تعريف شكل البيانات الخاصة
/// بقصص الأنبياء، ولا يحتوي على أي كود خاص بالواجهة.
class Prophet {
  final String id;
  final String name;
  final String title;
  final String shortDescription;
  final String story;
  final List<QuranEvidence> evidences;
  final List<String> lessons;

  const Prophet({
    required this.id,
    required this.name,
    required this.title,
    required this.shortDescription,
    required this.story,
    required this.evidences,
    required this.lessons,
  });

  /// تحويل البيانات من JSON إلى Prophet.
  factory Prophet.fromJson(Map<String, dynamic> json) {
    return Prophet(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      story: json['story'] as String? ?? '',
      evidences: (json['evidences'] as List<dynamic>? ?? [])
          .map(
            (item) => QuranEvidence.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      lessons: (json['lessons'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  /// تحويل Prophet إلى JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'shortDescription': shortDescription,
      'story': story,
      'evidences': evidences.map((e) => e.toJson()).toList(),
      'lessons': lessons,
    };
  }
}

/// نموذج الدليل القرآني المرتبط بقصة النبي.
class QuranEvidence {
  final String surah;
  final int surahNumber;
  final int ayah;
  final String text;

  const QuranEvidence({
    required this.surah,
    required this.surahNumber,
    required this.ayah,
    required this.text,
  });

  factory QuranEvidence.fromJson(Map<String, dynamic> json) {
    return QuranEvidence(
      surah: json['surah'] as String,
      surahNumber: json['surahNumber'] as int,
      ayah: json['ayah'] as int,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surah': surah,
      'surahNumber': surahNumber,
      'ayah': ayah,
      'text': text,
    };
  }
}
