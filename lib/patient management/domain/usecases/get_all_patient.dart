import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/domain/repositories/patient_repos.dart';

class GetAllPatients {
       final PatientRepository repository;

  GetAllPatients({required this.repository});


Future<Either<Failure, List<Patient>>> call() async {
  return await repository.getAllPatients();
  }
}
