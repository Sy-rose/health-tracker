import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/data/data_source/firebase_remote_datasource.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/data/data_source/health_metric_remote_datasource.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/data/repository_impl/health_metric_repo_impl.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/repositories/health_metric_repos.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/usecase/add_health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/usecase/delete_health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/usecase/edit_health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/usecase/get_all_health_metric_bypatient.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/usecase/get_all_health_metrics.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';
import 'package:health_metrics_tracker/patient%20management/data/data_source/patient_firebase_remote_datasource.dart';
import 'package:health_metrics_tracker/patient%20management/data/data_source/patient_remote_datasource.dart';
import 'package:health_metrics_tracker/patient%20management/data/repository_impl/patient_rep_impl.dart';
import 'package:health_metrics_tracker/patient%20management/domain/repositories/patient_repos.dart';
import 'package:health_metrics_tracker/patient%20management/domain/usecases/add_patient.dart';
import 'package:health_metrics_tracker/patient%20management/domain/usecases/delete_patient.dart';
import 'package:health_metrics_tracker/patient%20management/domain/usecases/edit_patient.dart';
import 'package:health_metrics_tracker/patient%20management/domain/usecases/get_all_patient.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Firebase instance
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);

  // Health Metric Feature
  // Presentation Layer
  serviceLocator.registerFactory(() => HealthMetricCubit(
      addHealthMetricUseCase: serviceLocator(),
      deleteHealthMetricUseCase: serviceLocator(),
      getAllHealthMetricByPatientUseCase: serviceLocator(),
      editHealthMetricUseCase: serviceLocator(),
      getAllHealthMetricsUseCase: serviceLocator()));

  // Domain Layer Use Cases
  serviceLocator.registerLazySingleton(
      () => AddHealthMetric(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => DeleteHealthMetric(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => EditHealthMetric(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetAllHealthMetricsByPatientId(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetAllHealthMetrics(repository: serviceLocator()));

  // Data Layer
  serviceLocator.registerLazySingleton<HealthMetricRepository>(
      () => HealthMetricRepositoryImplementation(serviceLocator()));
  serviceLocator.registerLazySingleton<HealthMetricRemoteDataSource>(
      () => HealthMetricFirebaseRemoteDatasource(serviceLocator()));

  // FEATURE 2: GUEST
  serviceLocator.registerFactory(() => PatientCubit(
      addPatientUseCase: serviceLocator(),
      deletePatientUseCase: serviceLocator(),
      editPatientUseCase: serviceLocator(),
      getAllPatientsUseCase: serviceLocator()));

  // Domain Layer
  serviceLocator
      .registerLazySingleton(() => AddPatient(repository: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DeletePatient(repository: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => EditPatient(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetAllPatients(repository: serviceLocator()));

  // Data Layer
  serviceLocator.registerLazySingleton<PatientRepository>(
      () => PatientRepositoryImplementation(serviceLocator()));

  // Data Source
  serviceLocator.registerLazySingleton<PatientRemoteDataSource>(
      () => PatientFirebaseRemoteDatasource(serviceLocator()));
}
