import 'dart:math';

class SAppStrings {
  static const String application = 'Bible Study';

  static String get randomImageUrl =>
      'https://picsum.photos/200?random=${Random().nextInt(100)}';
}
