class EnvironmentConfigSingleton {
  static final EnvironmentConfigSingleton instance = EnvironmentConfigSingleton._();
  EnvironmentConfigSingleton._();

  late final String env;
  late final String label;
  late final String apiUrl;
  late final bool featureEnabled;

  void init({
    required String env,
    required String label,
    required String apiUrl,
    required bool featureEnabled,
  }) {
    this.env = env;
    this.label = label;
    this.apiUrl = apiUrl;
    this.featureEnabled = featureEnabled;
  }
}
