// ignore_for_file: file_names
import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/repositories/health_metric_repos.dart';

class GetHealthMetricById {
  final HealthMetricRepository repository;

  GetHealthMetricById({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return await repository.getHealthMetricById(id);
  }
}
