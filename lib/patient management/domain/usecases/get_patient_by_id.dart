
// ignore_for_file: file_names
import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/domain/repositories/patient_repos.dart';

class GetPatientById {
  final PatientRepository repository;

  GetPatientById({required this.repository});

  Future<Either<Failure, Patient?>> call(String id) async {
    return await repository.getPatientById(id);
  }
}