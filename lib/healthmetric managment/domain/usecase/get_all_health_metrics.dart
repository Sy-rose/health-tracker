import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/repositories/health_metric_repos.dart';

class GetAllHealthMetrics {
  final HealthMetricRepository repository;

  GetAllHealthMetrics({required this.repository});

  Future<Either<Failure, List<HealthMetric>>> call() async {
    return await repository.getAllHealthMetrics();
  }
}
