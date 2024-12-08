import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/exceptions.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/patient%20management/data/data_source/patient_remote_datasource.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/domain/repositories/patient_repos.dart';

class PatientRepositoryImplementation implements PatientRepository {
  final PatientRemoteDataSource _remoteDataSource;

  const PatientRepositoryImplementation(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> addPatient(Patient patient) async {
    try {
      // ignore: void_checks
      return Right(await _remoteDataSource.addPatient(patient));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePatient(String id) async {
    try {
      // ignore: void_checks
      return Right(await _remoteDataSource.deletePatient(id));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  Future<Either<Failure, void>> editPatient(Patient patient) async {
    try {
      // ignore: void_checks
      return Right(await _remoteDataSource.editPatient(patient));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Patient>>> getAllPatients() async {
    try {
      // ignore: void_checks
      return Right(await _remoteDataSource.getAllPatients());
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Patient?>> getPatientById(String id) async {
    try {
      return Right(await _remoteDataSource.getPatientById(id));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

}
