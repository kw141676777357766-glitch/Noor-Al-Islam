import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/quran_model.dart';

/// مسؤول عن قراءة بيانات القرآن من ملف JSON المحلي.
class QuranData {
  QuranData._();

  static List<QuranSurah>? _cachedSurahs;

  /// تحميل جميع السور من quran.json.
  static Future<List<QuranSurah>> loadSurahs() async {
    // إذا تم تحميل البيانات سابقًا، نستخدم النسخة الموجودة في الذاكرة.
    if (_cachedSurahs != null) {
      return _cachedSurahs!;
    }

    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/quran.json');

      final dynamic decoded = jsonDecode(jsonString);

      if (decoded is! List) {
        throw const FormatException(
          'صيغة quran.json غير صحيحة: يجب أن تكون قائمة من السور.',
        );
      }

      final List<QuranSurah> surahs = decoded
          .map(
            (item) => QuranSurah.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();

      _cachedSurahs = surahs;

      return surahs;
    } catch (error) {
      throw Exception(
        'تعذر تحميل بيانات القرآن: $error',
      );
    }
  }

  /// البحث عن سورة برقمها.
  static Future<QuranSurah?> getSurah(int surahNumber) async {
    final surahs = await loadSurahs();

    for (final surah in surahs) {
      if (surah.number == surahNumber) {
        return surah;
      }
    }

    return null;
  }

  /// حذف النسخة المؤقتة من الذاكرة.
  ///
  /// نستخدمها أثناء التطوير إذا قمنا بتغيير quran.json.
  static void clearCache() {
    _cachedSurahs = null;
  }
}
