import 'package:flutter/material.dart';

class HealthMetricRow extends StatelessWidget {
  final String label;
  final dynamic value;

  const HealthMetricRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "$value",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class ViewHealthMetricRowPage extends StatelessWidget {
  final Map<String, dynamic> healthMetrics;

  const ViewHealthMetricRowPage({
    super.key,
    required this.healthMetrics,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Metric Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: healthMetrics.entries
              .map(
                (entry) => HealthMetricRow(
                  label: entry.key,
                  value: entry.value,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
