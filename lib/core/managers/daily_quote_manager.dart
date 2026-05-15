import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class DailyQuoteManager {
  static const String _lastQuoteDateKey = 'lastQuoteDate';
  static const String _todayQuoteKey = 'todayQuote';

  static final List<String> _quotes = [
    "Every child is unique and special. Celebrate their differences!",
    "Progress, not perfection. Every small step counts!",
    "Your love and patience make all the difference in your child's life.",
    "It's okay to take breaks. Self-care is not selfish.",
    "Celebrate today's victories, no matter how small they may be.",
    "You're doing an amazing job. Keep going!",
    "Every child learns at their own pace. Trust the process.",
    "Your consistent support helps your child thrive and grow.",
    "Take a deep breath. You've got this!",
    "Small victories lead to big achievements. Be proud!",
    "Embrace the journey, not just the destination.",
    "Your effort and dedication inspire your child every day.",
    "It's okay to ask for help. You don't have to do it alone.",
    "Celebrate growth, celebrate effort, celebrate YOU!",
    "One day at a time. You're stronger than you think.",
    "Your child is learning from your patience and love.",
    "Progress is progress, no matter how slow.",
    "You are enough. Your effort is enough.",
    "Today is a new opportunity to make a difference.",
    "Believe in your child, and they will believe in themselves.",
    "Consistency creates miracles. Keep going!",
    "Your voice of encouragement echoes in your child's heart.",
    "Challenges are opportunities for growth and learning.",
    "You're building a strong foundation of love and trust.",
    "Every moment with your child is a chance to inspire them.",
    "Balance effort with self-compassion. Be kind to yourself.",
    "Your child's potential is limitless with your support.",
    "Today, focus on what you can do, not what you can't.",
    "A patient heart creates a peaceful home.",
    "You are a wonderful parent. Trust yourself.",
  ];

  static Future<String> getDailyQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T').first;
    final lastDate = prefs.getString(_lastQuoteDateKey);

    // If it's a new day or no quote saved, get a new one
    if (lastDate != today) {
      final randomQuote =
          _quotes[DateTime.now().millisecondsSinceEpoch % _quotes.length];
      await prefs.setString(_lastQuoteDateKey, today);
      await prefs.setString(_todayQuoteKey, randomQuote);
      return randomQuote;
    }

    // Return today's quote
    return prefs.getString(_todayQuoteKey) ?? _quotes.first;
  }

  static Future<void> clearQuote() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastQuoteDateKey);
    await prefs.remove(_todayQuoteKey);
  }

  static Future<List<String>> getQuoteHistory({int days = 7}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = [];

    for (int i = 0; i < days; i++) {
      final dateKey =
          DateTime.now()
              .subtract(Duration(days: i))
              .toIso8601String()
              .split('T')
              .first;
      final quoteKey = 'quote_$dateKey';
      final quote = prefs.getString(quoteKey);
      if (quote != null) {
        history.add(quote);
      }
    }

    return history;
  }

  static String getRandomQuote() {
    return _quotes[DateTime.now().millisecondsSinceEpoch % _quotes.length];
  }

  static List<String> getAllQuotes() {
    return List.unmodifiable(_quotes);
  }
}
