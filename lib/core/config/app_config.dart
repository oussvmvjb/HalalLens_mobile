class AppConfig {
  const AppConfig._();

  static const _productionApiBaseUrl =
      'https://halallens-backend.onrender.com/api/v1';

  static const _configuredApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _productionApiBaseUrl,
  );
  static const apiBaseUrl =
      bool.fromEnvironment('dart.vm.product')
          ? _productionApiBaseUrl
          : _configuredApiBaseUrl;
}
