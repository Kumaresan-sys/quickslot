import 'package:flutter/services.dart';

class AppConfig {
  static const assetPath = 'assets/.env';
  static const apiBaseUrlKey = 'QUICKSLOT_API_BASE_URL';
  static const socketUrlKey = 'QUICKSLOT_SOCKET_URL';

  final String apiBaseUrl;
  final String socketUrl;

  const AppConfig({required this.apiBaseUrl, required this.socketUrl});

  static Future<AppConfig> load({
    AssetBundle? bundle,
    String path = assetPath,
  }) async {
    final env = await (bundle ?? rootBundle).loadString(path);
    return AppConfig.fromEnvString(env);
  }

  factory AppConfig.fromEnvString(String env) {
    final values = <String, String>{};

    for (final line in env.split('\n')) {
      final normalized = line.trim();
      if (normalized.isEmpty || normalized.startsWith('#')) continue;

      final separatorIndex = normalized.indexOf('=');
      if (separatorIndex <= 0) continue;

      final key = normalized.substring(0, separatorIndex).trim();
      final value = normalized.substring(separatorIndex + 1).trim();
      values[key] = _stripQuotes(value);
    }

    final config = AppConfig(
      apiBaseUrl: values[apiBaseUrlKey] ?? '',
      socketUrl: values[socketUrlKey] ?? '',
    );
    config.validate();
    return config;
  }

  static String _stripQuotes(String value) {
    if (value.length < 2) return value;

    final startsWithSingleQuote = value.startsWith("'");
    final startsWithDoubleQuote = value.startsWith('"');
    final hasMatchingSingleQuotes =
        startsWithSingleQuote && value.endsWith("'");
    final hasMatchingDoubleQuotes =
        startsWithDoubleQuote && value.endsWith('"');

    if (hasMatchingSingleQuotes || hasMatchingDoubleQuotes) {
      return value.substring(1, value.length - 1);
    }
    return value;
  }

  void validate() {
    if (apiBaseUrl.isEmpty || socketUrl.isEmpty) {
      throw StateError(
        'Missing required values in $assetPath: $apiBaseUrlKey and $socketUrlKey.',
      );
    }
  }
}
