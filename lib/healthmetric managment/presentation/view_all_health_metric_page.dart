import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/core/widgets/empty_state_list.dart';
import 'package:health_metrics_tracker/core/widgets/error_state_list.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/add_healthmetric_page.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_state.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/delete_health_metric_page.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/edit_healthmetric_page.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/view_health_metric_details_page.dart';
import 'package:intl/intl.dart';

class ViewAllHealthMetricsPage extends StatefulWidget {
  const ViewAllHealthMetricsPage({super.key});

  @override
  State<ViewAllHealthMetricsPage> createState() =>
      _ViewAllHealthMetricsPageState();
}

class _ViewAllHealthMetricsPageState extends State<ViewAllHealthMetricsPage> {
  late HealthMetricCubit _healthMetricCubit;
  Map<String, String> patientIdToName = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _healthMetricCubit = context.read<HealthMetricCubit>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    _healthMetricCubit.getAllHealthMetrics();
    await _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('patients').get();
      setState(() {
        patientIdToName = {
          for (var doc in snapshot.docs) doc.id: doc['name'] as String,
        };
      });
    } catch (e) {
      print("Error fetching patients: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/Designer.png', height: 30, width: 30),
        ),
        title: const Text(
          "Health Metrics",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
                description: 'Please add new health metrics.',
              );
            }

            final reversedMetrics = List.from(state.healthMetrics.reversed);

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: reversedMetrics.length,
              itemBuilder: (context, index) {
                final metric = reversedMetrics[index];
                String patientName =
                    patientIdToName[metric.patientId] ?? 'Unknown Patient';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    title: Text(
                      patientName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue),
                    ),
                    subtitle: Text(
                      'Date: ${DateFormat('yyyy-MM-dd').format(metric.date)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                                builder: (context) =>
                                    EditHealthMetricPage(healthMetric: metric),
                              ),
                            ).then((shouldRefresh) {
                              if (shouldRefresh == true) {
                                _fetchData();
                              }
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
                                    healthMetric: metric),
                              ),
                            ).then((_) {
                              _fetchData();
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
                            healthMetric: metric,
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
                _fetchData();
              },
              message: 'An error occurred while loading the health metrics.',
            );
          } else {
            return const EmptyStateList(
              imageAssetName: 'assets/Designer.png',
              title: 'No Health Metrics Found',
              description: 'Please add new health metrics.',
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
            _fetchData();
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
