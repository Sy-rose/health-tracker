import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_state.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteHealthMetricPage extends StatefulWidget {
  final HealthMetric healthMetric;

  const DeleteHealthMetricPage({
    super.key,
    required this.healthMetric,
  });

  @override
  State<DeleteHealthMetricPage> createState() => _DeleteHealthMetricPageState();
}

class _DeleteHealthMetricPageState extends State<DeleteHealthMetricPage> {
  late Future<String> _patientName;

  @override
  void initState() {
    super.initState();
    _patientName = _fetchPatientName(widget.healthMetric.patientId);
  }

  Future<String> _fetchPatientName(String patientId) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .get();

      if (doc.exists) {
        return doc['name'] ?? 'Unknown';
      }
    } catch (e) {
      return 'Error loading name';
    }
    return 'Unknown';
  }

  Future<void> _showDeleteConfirmationDialog(String patientName) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
          'Are you sure you want to delete the health metrics for $patientName?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              context
                  .read<HealthMetricCubit>()
                  .deleteHealthMetric(widget.healthMetric.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HealthMetricCubit, HealthMetricState>(
      listener: (context, state) {
        if (state is HealthMetricDelete) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Health Metric for ${widget.healthMetric.patientId} Deleted Successfully!'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(
              context, 'Health Metric Deleted'); // Redirects after deletion
        } else if (state is HealthMetricError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Delete Health Metric'),
          backgroundColor: Colors.red, // Red color for AppBar
        ),
        body: FutureBuilder<String>(
          future: _patientName,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading patient name'));
            } else if (snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.health_and_safety,
                      size: 150,
                      color: Colors.red, // Red color for the icon
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Patient: ${snapshot.data}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Date: ${DateFormat.yMMMd().format(widget.healthMetric.date)}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Systolic BP: ${widget.healthMetric.systolicBP} mmHg",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Diastolic BP: ${widget.healthMetric.diastolicBP} mmHg",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Heart Rate: ${widget.healthMetric.heartRate} bpm",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Weight: ${widget.healthMetric.weight} kg",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Blood Sugar: ${widget.healthMetric.bloodSugar} mg/dL",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<HealthMetricCubit, HealthMetricState>(
                      builder: (context, state) {
                        bool isDeleting = state is HealthMetricLoading;
                        return ElevatedButton(
                          onPressed: isDeleting
                              ? null
                              : () =>
                                  _showDeleteConfirmationDialog(snapshot.data!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Red color for button
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Text(
                                "Delete Health Metric",
                                style: TextStyle(fontSize: 18),
                              ),
                              if (isDeleting)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text("Patient name not found"));
            }
          },
        ),
      ),
    );
  }
}
