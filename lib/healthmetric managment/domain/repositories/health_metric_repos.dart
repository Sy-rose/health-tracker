import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';


abstract class HealthMetricRepository {
  Future<Either<Failure, void>> addHealthMetric(HealthMetric healthMetric);
  Future<Either<Failure, void>> editHealthMetric(HealthMetric healthMetric);
  Future<Either<Failure, void>> getHealthMetricById(String id);
  Future<Either<Failure, List<HealthMetric>>> getAllHealthMetricsByPatientId(String patientId);
  Future<Either<Failure, void>> deleteHealthMetric(String id);
  Future<Either<Failure, List<HealthMetric>>> getAllHealthMetrics();
}
