import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/patient%20management/domain/repositories/patient_repos.dart';

class DeletePatient {
  final PatientRepository repository;

  DeletePatient({required this.repository});

  Future<Either<Failure, void>> call(String id) async =>
      await repository.deletePatient(id);
}