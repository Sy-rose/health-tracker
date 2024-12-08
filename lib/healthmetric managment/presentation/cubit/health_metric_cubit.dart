import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/usecase/add_health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/usecase/edit_health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/usecase/get_all_health_metric_bypatient.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/usecase/get_all_health_metrics.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_state.dart';
import '../../../core/errors/failure.dart';
import '../../domain/usecase/delete_health_metric.dart';

const String noInternetErrorMessage =
    "Sync Failed: Changes saved on your device will sync once you're back online";

class HealthMetricCubit extends Cubit<HealthMetricState> {
  final AddHealthMetric addHealthMetricUseCase;
  final DeleteHealthMetric deleteHealthMetricUseCase;
  final GetAllHealthMetricsByPatientId getAllHealthMetricByPatientUseCase;
  final EditHealthMetric editHealthMetricUseCase;
  final GetAllHealthMetrics getAllHealthMetricsUseCase;

  HealthMetricCubit({
    required this.addHealthMetricUseCase,
    required this.deleteHealthMetricUseCase,
    required this.getAllHealthMetricByPatientUseCase,
    required this.editHealthMetricUseCase,
    required this.getAllHealthMetricsUseCase,
  }) : super(HealthMetricInitial());

  // Get all health metrics and cache them locally
  Future<void> getAllHealthMetric(String patientId) async {
    emit(HealthMetricLoading());

    try {
      final Either<Failure, List<HealthMetric>> result =
          await getAllHealthMetricByPatientUseCase.call(patientId).timeout(
              const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request Timed Out."));

      result.fold(
        (failure) => emit(HealthMetricError(failure.getMessage())),
        (healthMetrics) {
          emit(HealthMetricLoaded(healthMetrics: healthMetrics));
        },
      );
    } on TimeoutException catch (_) {
      emit(const HealthMetricError(
          "There seems to be a problem with your internet connection."));
    }
  }

  // Add a health metric and add it to the cache
  Future<void> addHealthMetric(HealthMetric healthMetric) async {
    emit(HealthMetricLoading());

    try {
      final Either<Failure, void> result = await addHealthMetricUseCase
          .call(healthMetric)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request Timed Out."));

      result.fold(
        (failure) => emit(HealthMetricError(failure.getMessage())),
        (_) {
          emit(HealthMetricAdded());
        },
      );
    } catch (_) {
      emit(const HealthMetricError(noInternetErrorMessage));
    }
  }

  // Edit a health metric and update it in the cache
  Future<void> editHealthMetric(HealthMetric healthMetric) async {
    emit(HealthMetricLoading());
    try {
      final result = await editHealthMetricUseCase.call(healthMetric).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(HealthMetricError(failure.getMessage())),
        (_) {
          emit(HealthMetricUpdated(healthMetric));
        },
      );
    } catch (_) {
      emit(const HealthMetricError(noInternetErrorMessage));
    }
  }

  // Delete a health metric from the cache
  Future<void> deleteHealthMetric(String id) async {
    emit(HealthMetricLoading());

    try {
      final Either<Failure, void> result = await deleteHealthMetricUseCase
          .call(id)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request Timed Out."));

      result.fold(
        (failure) => emit(HealthMetricError(failure.getMessage())),
        (_) {
          emit(HealthMetricDelete());
        },
      );
    } catch (_) {
      emit(const HealthMetricError(noInternetErrorMessage));
    }
  }

  Future<void> getAllHealthMetrics() async {
    emit(HealthMetricLoading());

    try {
      final result = await getAllHealthMetricsUseCase.call().timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException('Request timed out'));
      result.fold(
        (failure) => emit(HealthMetricError(failure.getMessage())),
        (healthMetrics) {
          emit(HealthMetricLoaded(healthMetrics: healthMetrics));
        },
      );
    } on TimeoutException catch (_) {
      emit(const HealthMetricError(
          "There seems to be a problem with your internet connection"));
    }
  }

  // void getHealthMetrics() {}

  // void addEditHealthMetric(HealthMetric healthMetric) {}
}
