// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:intl/intl.dart';

class ViewHealthMetricDetailsPage extends StatelessWidget {
  final HealthMetric healthMetric;
  final String patientName;

  const ViewHealthMetricDetailsPage({
    Key? key,
    required this.healthMetric,
    required this.patientName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Patient",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text(
                  "Patient Name: $patientName",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Date Registered: ${DateFormat.yMMMd().format(healthMetric.date)}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const Divider(height: 32, thickness: 1),
                _buildMetricRow("Systolic BP", "${healthMetric.systolicBP} mmHg"),
                _buildMetricRow("Diastolic BP", "${healthMetric.diastolicBP} mmHg"),
                _buildMetricRow("Weight", "${healthMetric.weight} kg"),
                _buildMetricRow("Blood Sugar", "${healthMetric.bloodSugar} mg/dL"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build metric rows with consistent styling
  Widget _buildMetricRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
