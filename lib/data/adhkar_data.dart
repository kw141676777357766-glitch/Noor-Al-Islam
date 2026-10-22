import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/adhkar_model.dart';

/// تحميل أقسام الأذكار من ملف JSON المحلي.
class AdhkarData {
  AdhkarData._();

  static List<AdhkarCategory>? _cachedCategories;

  /// تحميل جميع أقسام الأذكار.
  static Future<List<AdhkarCategory>> loadCategories() async {
    if (_cachedCategories != null) {
      return _cachedCategories!;
    }

    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/adhkar.json');

      final dynamic decodedData = jsonDecode(jsonString);

      if (decodedData is! Map<String, dynamic>) {
        throw const FormatException(
          'ملف adhkar.json يجب أن يحتوي على كائن JSON.',
        );
      }

      final dynamic rawCategories = decodedData['categories'];

      if (rawCategories is! List) {
        throw const FormatException(
          'يجب أن يحتوي ملف adhkar.json على قائمة categories.',
        );
      }

      final List<AdhkarCategory> categories = rawCategories
          .map(
            (item) => AdhkarCategory.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();

      _cachedCategories = categories;

      return categories;
    } catch (error) {
      throw Exception('تعذر تحميل الأذكار: $error');
    }
  }

  /// مسح البيانات المخزنة مؤقتًا عند الحاجة.
  static void clearCache() {
    _cachedCategories = null;
  }
}
