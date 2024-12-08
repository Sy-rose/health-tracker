// ignore: unused_import
import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';



abstract class PatientRemoteDataSource {
  PatientRemoteDataSource();

  Future<void> addPatient(Patient patient);
  Future<void> editPatient(Patient patient);
  Future<Patient?>getPatientById(String id);
  Future<List<Patient>>getAllPatients();
  Future<void>deletePatient(String id);
}


