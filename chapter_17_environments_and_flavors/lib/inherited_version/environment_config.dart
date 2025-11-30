import 'package:flutter/widgets.dart';
import '../core/flavor.dart';

class EnvironmentConfig extends InheritedWidget {
  const EnvironmentConfig({
    super.key,
    required this.flavor,
    required this.label,
    required this.apiUrl,
    required this.featureEnabled,
    required super.child,
  });

  final Flavor flavor;
  final String label;
  final String apiUrl;
  final bool featureEnabled;

  static EnvironmentConfig of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<EnvironmentConfig>();
    assert(result != null, 'No EnvironmentConfig found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(EnvironmentConfig oldWidget) => false;
}
