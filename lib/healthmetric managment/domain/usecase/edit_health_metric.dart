import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/repositories/health_metric_repos.dart';

class EditHealthMetric {
  final HealthMetricRepository repository;

  EditHealthMetric({required this.repository});

  Future<Either<Failure, void>> call(HealthMetric healthMetric) async => 
    repository.editHealthMetric(healthMetric);
}
