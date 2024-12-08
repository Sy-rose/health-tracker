import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/domain/repositories/patient_repos.dart';


// edit_patient.dart
class EditPatient {
  final PatientRepository repository;

  EditPatient({required this.repository});

  Future<Either<Failure, void>> call(Patient patient) async {
    return await repository.editPatient(patient);
  }
}