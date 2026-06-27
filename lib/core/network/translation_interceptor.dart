import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:translator/translator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:child_monitor_app/core/di/service_locator.dart';

class TranslationInterceptor extends Interceptor {
  final GoogleTranslator translator = GoogleTranslator();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.data != null) {
      try {
        response.data = await _translateData(response.data);
      } catch (e) {
        // Translation failed, proceed with original data
        debugPrint('TranslationInterceptor Error: $e');
      }
    }
    handler.next(response);
  }

  // Check if string contains Arabic characters
  bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  Future<dynamic> _translateData(dynamic data) async {
    if (data is String) {
      try {
        // Skip translating URLs or obvious JSON strings
        if (data.startsWith('http') || data.startsWith('{') || data.startsWith('[')) {
          return data;
        }

        // Get current language from SharedPreferences via GetIt
        final prefs = getIt<SharedPreferences>();
        final appLang = prefs.getString('app_lang') ?? 'en';

        final isArabic = _containsArabic(data);

        if (appLang == 'ar') {
          // User wants Arabic. If data is English, translate it.
          if (!isArabic && data.trim().isNotEmpty) {
            final translation = await translator.translate(data, to: 'ar');
            return translation.text;
          }
          return data;
        } else {
          // User wants English. If data is Arabic, translate it.
          if (isArabic) {
            final translation = await translator.translate(data, from: 'ar', to: 'en');
            return translation.text;
          }
          return data;
        }
      } catch (e) {
        return data; 
      }
    } else if (data is Map) {
      final translatedMap = <String, dynamic>{};
      final futures = data.entries.map((entry) async {
        translatedMap[entry.key.toString()] = await _translateData(entry.value);
      });
      await Future.wait(futures);
      return translatedMap;
    } else if (data is List) {
      final translatedList = <dynamic>[];
      final futures = data.map((item) async {
        return await _translateData(item);
      });
      translatedList.addAll(await Future.wait(futures));
      return translatedList;
    }
    return data;
  }
}
