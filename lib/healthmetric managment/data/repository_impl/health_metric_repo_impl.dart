import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/exceptions.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/data/data_source/health_metric_remote_datasource.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/repositories/health_metric_repos.dart';

class HealthMetricRepositoryImplementation implements HealthMetricRepository {
  final HealthMetricRemoteDataSource _remoteDataSource;

  const HealthMetricRepositoryImplementation(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> addHealthMetric(healthMetric) async {
    try {
      // ignore: void_checks
      return Right(await _remoteDataSource.addHealthMetric(healthMetric));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
// ignore: override_on_non_overriding_member
  Future<Either<Failure, void>> deleteHealthMetric(String id) async {
    try {
      // ignore: void_checks
      return Right(await _remoteDataSource.deleteHealthMetric(id));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> editHealthMetric(healthMetric) async {
    try {
      // ignore: void_checks
      return Right(await _remoteDataSource.editHealthMetric(healthMetric));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HealthMetric>>> getAllHealthMetrics() async {
    try {
      return Right(await _remoteDataSource.getAllHealthMetrics());
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> getHealthMetricById(String id) async {
    try {
      // ignore: void_checks
      return Right(await _remoteDataSource.getHealthMetricById(id));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, List>> getHealthMetricsByPatientId(
      String patientId) async {
    try {
      return Right(
          (await _remoteDataSource.getHealthMetricById(patientId)) as List);
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
