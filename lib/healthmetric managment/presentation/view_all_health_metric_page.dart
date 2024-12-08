import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:health_metrics_tracker/healthmetric%20managment/presentation/view_health_metric_details_page.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/add_healthmetric_page.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_state.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/delete_health_metric_page.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/edit_page.dart';
import 'package:health_metrics_tracker/core/widgets/empty_state_list.dart';
import 'package:health_metrics_tracker/core/widgets/error_state_list.dart';

class ViewAllHealthMetricsPage extends StatefulWidget {
  const ViewAllHealthMetricsPage({Key? key}) : super(key: key);

  @override
  State<ViewAllHealthMetricsPage> createState() =>
      _ViewAllHealthMetricsPageState();
}

class _ViewAllHealthMetricsPageState extends State<ViewAllHealthMetricsPage> {
  Map<String, String> patientNames = {};

  @override
  void initState() {
    super.initState();
    context.read<HealthMetricCubit>().getAllHealthMetrics();
  }

  Future<String> _fetchPatientName(String patientId) async {
    if (patientNames.containsKey(patientId)) {
      return patientNames[patientId]!;
    }

    try {
      var doc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .get();

      if (doc.exists) {
        String patientName = doc['name'];
        if (mounted) {
          setState(() {
            patientNames[patientId] = patientName;
          });
        }
        return patientName;
      }
    } catch (e) {
      print("Error fetching patient name: $e");
    }
    return "Unknown";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/Designer.png',
            height: 30,
            width: 30,
          ),
        ),
        title: const Text(
          "Health Metrics",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 5,
      ),
      body: BlocBuilder<HealthMetricCubit, HealthMetricState>(
        builder: (context, state) {
          if (state is HealthMetricLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HealthMetricLoaded) {
            if (state.healthMetrics.isEmpty) {
              return const EmptyStateList(
                imageAssetName: 'assets/Designer.png',
                title: 'No Health Metrics Found',
                description: 'Please add health metrics for patients.',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.healthMetrics.length,
              itemBuilder: (context, index) {
                final currentMetric = state.healthMetrics[index];

                String patientName =
                    patientNames[currentMetric.patientId] ?? "Loading...";

                // Fetch the patient name if not already fetched
                _fetchPatientName(currentMetric.patientId);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    title: Text(
                      patientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Date Registered: ${DateFormat('yyyy-MM-dd').format(currentMetric.date)}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditHealthMetricPage(
                                  healthMetric: currentMetric,
                                ),
                              ),
                            ).then((_) {
                              context
                                  .read<HealthMetricCubit>()
                                  .getAllHealthMetrics();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeleteHealthMetricPage(
                                  healthMetric: currentMetric,
                                ),
                              ),
                            ).then((_) {
                              context
                                  .read<HealthMetricCubit>()
                                  .getAllHealthMetrics();
                            });
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewHealthMetricDetailsPage(
                            healthMetric: currentMetric,
                            patientName: patientName,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is HealthMetricError) {
            return ErrorStateList(
              imageAssetName: 'assets/images/error.png',
              errorMessage: state.message,
              onRetry: () {
                context.read<HealthMetricCubit>().getAllHealthMetrics();
              },
              message: 'An error occurred while loading the health metrics.',
            );
          } else {
            return const EmptyStateList(
              imageAssetName: 'assets/Designer.png',
              title: 'No Health Metrics Found',
              description: 'Please add health metrics.',
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHealthMetricPage(),
            ),
          );
          if (result == true) {
            context.read<HealthMetricCubit>().getAllHealthMetrics();
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
