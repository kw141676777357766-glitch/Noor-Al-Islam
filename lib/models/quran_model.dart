/// نموذج يمثل آية واحدة من القرآن الكريم.
class QuranAyah {
  final int number;
  final String text;

  const QuranAyah({
    required this.number,
    required this.text,
  });

  factory QuranAyah.fromJson(Map<String, dynamic> json) {
    return QuranAyah(
      number: json['number'] as int,
      text: json['text'] as String,
    );
  }
}

/// نموذج يمثل سورة كاملة.
class QuranSurah {
  final int number;
  final String name;
  final String englishName;
  final String revelationType;
  final List<QuranAyah> ayahs;

  const QuranSurah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.revelationType,
    required this.ayahs,
  });

  factory QuranSurah.fromJson(Map<String, dynamic> json) {
    final ayahsJson = json['ayahs'] as List<dynamic>? ?? [];

    return QuranSurah(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String? ?? '',
      revelationType: json['revelationType'] as String? ?? '',
      ayahs: ayahsJson
          .map(
            (ayah) => QuranAyah.fromJson(
              Map<String, dynamic>.from(ayah as Map),
            ),
          )
          .toList(),
    );
  }
}
