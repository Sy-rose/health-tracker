import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';

abstract class HealthMetricRemoteDataSource {
  HealthMetricRemoteDataSource(Object object);

  Future<void> addHealthMetric(HealthMetric healthMetric);
  Future<void> editHealthMetric(HealthMetric healthMetric);
  Future<List<HealthMetric>> getAllHealthMetrics();
  Future<void> getHealthMetricById(String id);
  Future<List> getHealthMetricByPatientId(String patientId);
  Future<void> deleteHealthMetric(String id);
}
