import 'package:hive/hive.dart';

final class HiveHelper {
  static Box? _box;

  static Future<void> initHive() async {
    _box ??= await Hive.openBox('locationBox');
  }

  static Box? get box => _box;
}
