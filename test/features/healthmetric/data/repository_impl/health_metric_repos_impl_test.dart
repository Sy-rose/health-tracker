import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/data/repository_impl/health_metric_repo_impl.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'health_metric_remote_datasource_mock.dart';

void main() {
  late MockHealthMetricRemoteDataSource mockHealthMetricRemoteDataSource;
  late HealthMetricRepositoryImplementation healthMetricRepositoryUnderTest;

  setUp(() {
    mockHealthMetricRemoteDataSource = MockHealthMetricRemoteDataSource();
    healthMetricRepositoryUnderTest =
        HealthMetricRepositoryImplementation(mockHealthMetricRemoteDataSource);
  });
  final testHealthMetric = HealthMetric(
    id: '1',
    patientId: "p001",
    date: DateTime(2024, 9, 10),
    systolicBP: 120.0,
    diastolicBP: 80.0,
    heartRate: 70.0,
    weight: 70.0,
    bloodSugar: 100.0,
  );

  final healthMetricsList = [
    HealthMetric(
      id: '1',
      patientId: '123',
      date: DateTime.now(),
      systolicBP: 120.0,
      diastolicBP: 80.0,
      heartRate: 72.0,
      weight: 70.0,
      bloodSugar: 100.0,
    ),
    HealthMetric(
      id: '2',
      patientId: '456',
      date: DateTime.now(),
      systolicBP: 130.0,
      diastolicBP: 85.0,
      heartRate: 75.0,
      weight: 75.0,
      bloodSugar: 110.0,
    ),
  ];

  // ignore: unused_local_variable
  final healthmetricList = [testHealthMetric];

  //ignore: use_function_type_syntax_for_parameters
  group('getAllHealthMetrics', () {
    test('should return a list of HealthMetric', () async {
      when(() => mockHealthMetricRemoteDataSource.getAllHealthMetrics())
          .thenAnswer((_) async => healthMetricsList);

      final result =
          await healthMetricRepositoryUnderTest.getAllHealthMetrics();

      expect(result, equals(Right(healthMetricsList)));
      verify(() => mockHealthMetricRemoteDataSource.getAllHealthMetrics())
          .called(1);
    });
  });
  group('addHealthMetric', () {
    test('should return Right<void> when the remote call is successful',
        () async {
      //Arrange:
      when(() => mockHealthMetricRemoteDataSource.addHealthMetric(
          testHealthMetric)).thenAnswer((_) async => Future.value());

      // Act: Call the repository method
      final result = await healthMetricRepositoryUnderTest
          .addHealthMetric(testHealthMetric);

      // Assert: Check that the result is Right(void)
      expect(result, const Right(null));
      verify(() => mockHealthMetricRemoteDataSource
          .addHealthMetric(testHealthMetric)).called(1);
      verifyNoMoreInteractions(mockHealthMetricRemoteDataSource);
    });

    test('should return Left<void> when the remote call throws an exception',
        () async {
      // Arrange
      when(() => mockHealthMetricRemoteDataSource
          .addHealthMetric(testHealthMetric)).thenThrow(Exception());

      // Act
      final result = await healthMetricRepositoryUnderTest
          .addHealthMetric(testHealthMetric);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockHealthMetricRemoteDataSource
          .addHealthMetric(testHealthMetric)).called(1);
      verifyNoMoreInteractions(mockHealthMetricRemoteDataSource);
    });
  });

  group('deleteHealthMetric', () {
    test('should return Right<void> when the remote call is successful',
        () async {
      // Arrange
      when(() => mockHealthMetricRemoteDataSource.deleteHealthMetric('1'))
          .thenAnswer((_) async => Future.value());

      // Act
      final result =
          await healthMetricRepositoryUnderTest.deleteHealthMetric('1');

      // Assert
      expect(result, const Right(null));
      verify(() => mockHealthMetricRemoteDataSource.deleteHealthMetric('1'))
          .called(1);
      verifyNoMoreInteractions(mockHealthMetricRemoteDataSource);
    });

    test('should return Left<void> when the remote call throws an exception',
        () async {
      // Arrange
      when(() => mockHealthMetricRemoteDataSource.deleteHealthMetric('1'))
          .thenThrow(Exception());

      // Act
      final result =
          await healthMetricRepositoryUnderTest.deleteHealthMetric('1');

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockHealthMetricRemoteDataSource.deleteHealthMetric('1'))
          .called(1);
      verifyNoMoreInteractions(mockHealthMetricRemoteDataSource);
    });
  });

  group('getHealthMetricById', () {
    test('should return Right<void> when the remote call is successful',
        () async {
      // Arrange
      when(() => mockHealthMetricRemoteDataSource.getHealthMetricById('1'))
          // ignore: null_argument_to_non_null_type
          .thenAnswer((_) async => Future.value());

      // Act
      final result =
          await healthMetricRepositoryUnderTest.getHealthMetricById('1');

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockHealthMetricRemoteDataSource.getHealthMetricById('1'))
          .called(1);
      verifyNoMoreInteractions(mockHealthMetricRemoteDataSource);
    });

    test('should return Left<void> when the remote call throws an exception',
        () async {
      // Arrange
      when(() => mockHealthMetricRemoteDataSource.getHealthMetricById('1'))
          .thenThrow(Exception());

      // Act
      final result =
          await healthMetricRepositoryUnderTest.getHealthMetricById('1');

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockHealthMetricRemoteDataSource.getHealthMetricById('1'))
          .called(1);
      verifyNoMoreInteractions(mockHealthMetricRemoteDataSource);
    });
  });

  group('editHealthMetric', () {
    test('should return Right<void> when the remote call is successful',
        () async {
      // Arrange
      when(() => mockHealthMetricRemoteDataSource.editHealthMetric(
          testHealthMetric)).thenAnswer((_) async => Future.value());

      // Act
      final result = await healthMetricRepositoryUnderTest
          .editHealthMetric(testHealthMetric);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockHealthMetricRemoteDataSource
          .editHealthMetric(testHealthMetric)).called(1);
      verifyNoMoreInteractions(mockHealthMetricRemoteDataSource);
    });

    test('should return Left<void> when the remote call throws an exception',
        () async {
      // Arrange
      when(() => mockHealthMetricRemoteDataSource
          .editHealthMetric(testHealthMetric)).thenThrow(Exception());

      // Act
      final result = await healthMetricRepositoryUnderTest
          .editHealthMetric(testHealthMetric);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockHealthMetricRemoteDataSource
          .editHealthMetric(testHealthMetric)).called(1);
      verifyNoMoreInteractions(mockHealthMetricRemoteDataSource);
    });
  });
}
