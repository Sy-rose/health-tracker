import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/domain/repositories/patient_repos.dart';


// add_patient.dart
class AddPatient {
  final PatientRepository repository;

  AddPatient({required this.repository});

  Future<Either<Failure, void>> call(Patient patient) async {
    return await repository.addPatient(patient);
  }
}
