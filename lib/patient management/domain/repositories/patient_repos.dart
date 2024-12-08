import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';



abstract class PatientRepository {
  Future<Either<Failure, void>> addPatient(Patient patient);
  Future<Either<Failure, void>> editPatient(Patient patient);
  Future<Either<Failure, Patient?>> getPatientById(String id);
  Future<Either<Failure, List<Patient>>> getAllPatients();
  Future<Either<Failure, void>> deletePatient(String id);
}

