import 'package:flutter/foundation.dart';

class AppConfig {
  const AppConfig._();

  // Base URL for the backend API when running locally.
  // For mobile (Android emulator) use 10.0.2.2, for iOS simulator localhost works.
  // For web (Chrome) use localhost directly.
  static const _mobileApiBaseUrl =
      const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000/api/v1');
  static const _webApiBaseUrl = 'http://localhost:8000/api/v1';

  // Choose the correct base URL depending on the platform.
  // In release builds we still use the environment‑override for mobile.
  // For web we always point to localhost because the dev server runs on the same machine.
  static const apiBaseUrl =
      kIsWeb
          ? _webApiBaseUrl
          : _mobileApiBaseUrl;


}
