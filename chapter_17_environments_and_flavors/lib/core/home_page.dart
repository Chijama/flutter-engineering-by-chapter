import 'package:flutter/material.dart';

/// Simple view that displays active environment and flavor info.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.envLabel,
    required this.flavorName,
    required this.apiUrl,
    required this.featureEnabled,
    this.hint,
  });

  final String envLabel;
  final String flavorName;
  final String apiUrl;
  final bool featureEnabled;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$envLabel • $flavorName')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _row('Environment', envLabel),
          _row('Flavor', flavorName),
          _row('API URL', apiUrl),
          _row('Feature Enabled', featureEnabled.toString()),
          if (hint != null) ...[
            const SizedBox(height: 16),
            Text(hint!),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
      contentPadding: EdgeInsets.zero,
    );
  }
}
