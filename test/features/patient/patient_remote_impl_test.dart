import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';

import 'package:health_metrics_tracker/patient%20management/data/data_source/patient_remote_datasource.dart';
import 'package:health_metrics_tracker/patient%20management/data/repository_impl/patient_rep_impl.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';

import 'package:mocktail/mocktail.dart';

import 'patient_remote_datasource_mock.dart';

void main() {
  late MockPatientRemoteDataSource mockPatientRemoteDataSource;
  late PatientRepositoryImplementation patientRepositoryUnderTest;

  setUp(() {
    mockPatientRemoteDataSource = MockPatientRemoteDataSource();
    patientRepositoryUnderTest =
        PatientRepositoryImplementation(mockPatientRemoteDataSource as PatientRemoteDataSource);
  });

  const testPatient = Patient(
      id: '1',
      name: 'Sairose',
      age: 30,
      gender: 'Female',
      contactInfo: "09123456789");

  final patientList = [testPatient];

  // ignore: use_function_type_syntax_for_parameters
  group('addPatient', () {
    test('should return Right<void> when the remote call is successful',
        () async {
      // Arrange: Set up the mock to return success
      when(() => mockPatientRemoteDataSource.addPatient(testPatient))
          .thenAnswer((_) async => Future.value());

      // Act: Call the repository method
      final result = await patientRepositoryUnderTest.addPatient(testPatient);

      // Assert: Check that the result is Right(void)
      expect(result, const Right(null));
      verify(() => mockPatientRemoteDataSource.addPatient(testPatient))
          .called(1);
      verifyNoMoreInteractions(mockPatientRemoteDataSource);
    });

    test('should return Left<void> when the remote call throws an exception',
        () async {
      // Arrange: Set up the mock to throw an exception
      when(() => mockPatientRemoteDataSource.addPatient(testPatient))
          .thenThrow(Exception());

      // Act: Call the repository method
      final result = await patientRepositoryUnderTest.addPatient(testPatient);

      // Assert: Check that the result is Left<Failure>
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockPatientRemoteDataSource.addPatient(testPatient))
          .called(1);
      verifyNoMoreInteractions(mockPatientRemoteDataSource);
    });
  });

  group('deletePatient', () {
    test('should return Right<void> when the remote call is successful',
        () async {
      // Arrange: Set up the mock to return success
      when(() => mockPatientRemoteDataSource.deletePatient('1'))
          .thenAnswer((_) async => Future.value());

      // Act: Call the repository method
      final result = await patientRepositoryUnderTest.deletePatient('1');

      // Assert: Check that the result is Right(void)
      expect(result, const Right(null));
      verify(() => mockPatientRemoteDataSource.deletePatient('1')).called(1);
      verifyNoMoreInteractions(mockPatientRemoteDataSource);
    });

    test('should return Left<void> when the remote call throws an exception',
        () async {
      // Arrange: Set up the mock to throw an exception
      when(() => mockPatientRemoteDataSource.deletePatient('1'))
          .thenThrow(Exception());

      // Act: Call the repository method
      final result = await patientRepositoryUnderTest.deletePatient('1');

      // Assert: Check that the result is Left<Failure>
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockPatientRemoteDataSource.deletePatient('1')).called(1);
      verifyNoMoreInteractions(mockPatientRemoteDataSource);
    });
  });

  group('editPatient', () {
    test('should return Right<void> when the remote call is successful',
        () async {
      // Arrange: Set up the mock to return success
      when(() => mockPatientRemoteDataSource.editPatient(testPatient))
          .thenAnswer((_) async => Future.value());

      // Act: Call the repository method
      final result = await patientRepositoryUnderTest.editPatient(testPatient);

      // Assert: Check that the result is Right(void)
      expect(result, const Right(null));
      verify(() => mockPatientRemoteDataSource.editPatient(testPatient))
          .called(1);
      verifyNoMoreInteractions(mockPatientRemoteDataSource);
    });

    test('should return Left<void> when the remote call throws an exception',
        () async {
      // Arrange: Set up the mock to throw an exception
      when(() => mockPatientRemoteDataSource.editPatient(testPatient))
          .thenThrow(Exception());

      // Act: Call the repository method
      final result = await patientRepositoryUnderTest.editPatient(testPatient);

      // Assert: Check that the result is Left<Failure>
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockPatientRemoteDataSource.editPatient(testPatient))
          .called(1);
      verifyNoMoreInteractions(mockPatientRemoteDataSource);
    });
  });

  group('getAllPatients', () {
    test('should return Right<void> when the remote call is successful',
        () async {
      // Arrange: Set up the mock to return success
      when(() => mockPatientRemoteDataSource.getAllPatients())
          .thenAnswer((_) async => patientList);
      // Act: Call the repository method
      final result = await patientRepositoryUnderTest.getAllPatients();

      // Assert: Check that the result is Right(void)
      expect(result, Right(patientList));
      verify(() => mockPatientRemoteDataSource.getAllPatients());
      verifyNoMoreInteractions(mockPatientRemoteDataSource);
    });

    test('should return Left<void> when the remote call throws an exception',
        () async {
      // Arrange: Set up the mock to throw an exception
      when(() => mockPatientRemoteDataSource.getAllPatients())
          .thenThrow(Exception());

      // Act: Call the repository method
      final result = await patientRepositoryUnderTest.getAllPatients();

      // Assert: Check that the result is Left<Failure>
      expect(result, isA<Left<Failure, List<Patient>>>());
      verify(() => mockPatientRemoteDataSource.getAllPatients());
      verifyNoMoreInteractions(mockPatientRemoteDataSource);
    });
  });

  group('getPatientById', () {
    test('should return Right<void> when the remote call is successful',
        () async {
      // Arrange: Set up the mock to return success
      when(() => mockPatientRemoteDataSource.getPatientById('1'))
          // ignore: null_argument_to_non_null_type
          .thenAnswer((_) async => Future.value());

      // Act: Call the repository method
      final result = await patientRepositoryUnderTest.getPatientById('1');

      // Assert: Check that the result is Right(void)
      expect(result, const Right(null));
      verify(() => mockPatientRemoteDataSource.getPatientById('1'));
      verifyNoMoreInteractions(mockPatientRemoteDataSource);
    });

    test('should return Left<void> when the remote call throws an exception',
        () async {
      // Arrange: Set up the mock to throw an exception
      when(() => mockPatientRemoteDataSource.getPatientById('1'))
          .thenThrow(Exception());

      // Act: Call the repository method
      final result = await patientRepositoryUnderTest.getPatientById('1');

      // Assert: Check that the result is Left<Failure>
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockPatientRemoteDataSource.getPatientById('1'));
      verifyNoMoreInteractions(mockPatientRemoteDataSource);
    });
  });
}
