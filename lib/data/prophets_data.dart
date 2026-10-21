import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/prophet_model.dart';

/// مسؤول عن تحميل بيانات قصص الأنبياء من ملف JSON المحلي.
///
/// يتم تحميل البيانات مرة واحدة فقط أثناء تشغيل التطبيق،
/// ثم يتم الاحتفاظ بها في الذاكرة لتجنب إعادة قراءة الملف
/// في كل مرة يفتح فيها المستخدم شاشة القصص.
class ProphetsData {
  ProphetsData._();

  static List<Prophet>? _cachedProphets;

  /// تحميل جميع الأنبياء.
  static Future<List<Prophet>> loadProphets() async {
    // إذا كانت البيانات محملة مسبقًا، نعيد استخدامها.
    if (_cachedProphets != null) {
      return _cachedProphets!;
    }

    try {
      // قراءة ملف JSON من assets.
      final String jsonString =
          await rootBundle.loadString('assets/data/prophets.json');

      // تحويل النص إلى بيانات JSON.
      final dynamic decodedData = jsonDecode(jsonString);

      // التأكد أن البيانات عبارة عن قائمة.
      if (decodedData is! List) {
        throw const FormatException(
          'ملف prophets.json يجب أن يحتوي على قائمة من الأنبياء.',
        );
      }

      // تحويل كل عنصر إلى Prophet.
      final List<Prophet> prophets = decodedData
          .map(
            (item) => Prophet.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();

      // حفظ البيانات في الذاكرة.
      _cachedProphets = prophets;

      return prophets;
    } catch (error) {
      throw Exception(
        'تعذر تحميل بيانات قصص الأنبياء: $error',
      );
    }
  }

  /// مسح البيانات المخزنة مؤقتًا.
  ///
  /// نحتاجها فقط إذا قمنا بتحديث ملف JSON أثناء التطوير
  /// ونريد إجبار التطبيق على إعادة قراءته.
  static void clearCache() {
    _cachedProphets = null;
  }
}
