// part of 'patient_cubit.dart';
// Define different states for PatientCubit
import 'package:equatable/equatable.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';

abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object?> get props => [];

  String get message => '';


}

// Initial State
class PatientInitial extends PatientState {}

// Loading State
class PatientLoading extends PatientState {}

// Success State (with List<Patient>)
class PatientLoaded extends PatientState {
  final List<Patient> patients;

  const PatientLoaded({required this.patients});

  @override
  List<Object?> get props => [patients];
}

// State indicating a patient has been added
class PatientAdded extends PatientState {
  final String patientName;

  const PatientAdded({required this.patientName});

  @override
  List<Object> get props => [patientName];
}

// State indicating a patient has been deleted
class PatientDelete extends PatientState {
  get patientName => null;
}

// State indicating a patient has been updated
class PatientUpdated extends PatientState {
  final Patient newPatient;

  const PatientUpdated(this.newPatient);

  @override
  List<Object?> get props => [newPatient];
}

// Error State (with error message)
class PatientError extends PatientState {
  final String message;

  const PatientError(this.message);

  @override
  List<Object?> get props => [message];
}

