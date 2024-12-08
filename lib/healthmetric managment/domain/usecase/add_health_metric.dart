import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/repositories/health_metric_repos.dart';


class AddHealthMetric {
  final HealthMetricRepository repository;

  AddHealthMetric({required this.repository});

  Future<Either<Failure, void>> call(HealthMetric healthMetric) async {
    return await repository.addHealthMetric(healthMetric);
  }
}

  
