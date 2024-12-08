  import 'dart:async';
  import 'package:bloc/bloc.dart';
  import 'package:dartz/dartz.dart';
  import 'package:health_metrics_tracker/core/errors/failure.dart';
  import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
  import 'package:health_metrics_tracker/patient%20management/domain/usecases/add_patient.dart';
  import 'package:health_metrics_tracker/patient%20management/domain/usecases/delete_patient.dart';
  import 'package:health_metrics_tracker/patient%20management/domain/usecases/edit_patient.dart';
  import 'package:health_metrics_tracker/patient%20management/domain/usecases/get_all_patient.dart';
  import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_state.dart';

  const String noInternetErrorMessage =
      "Sync Failed: Changes saved on your device will sync once you're back online";
  const Duration timeoutDuration = Duration(seconds: 10); // Timeout constant

  class PatientCubit extends Cubit<PatientState> {
    final AddPatient addPatientUseCase;
    final DeletePatient deletePatientUseCase;
    final GetAllPatients getAllPatientsUseCase;
    final EditPatient editPatientUseCase;

    PatientCubit({
      required this.addPatientUseCase,
      required this.deletePatientUseCase,
      required this.getAllPatientsUseCase,
      required this.editPatientUseCase,
    }) : super(PatientInitial());

    // Common method for handling timeout and fetching results
    // Common method for handling timeout and fetching results
  // Common method for handling timeout and fetching results
  Future<void> _handleRequest<T>(
    Future<Either<Failure, T>> request, // The asynchronous request
    Function(T) onSuccess, // Callback for success
  ) async {
    try {
      // Await the request with a timeout
      final Either<Failure, T> result = await request.timeout(
        timeoutDuration,
        onTimeout: () => throw TimeoutException("Request Timed Out."),
      );

      // Handle the result of the request
      result.fold(
        // Emit error state if failure occurs
        (failure) {
          // ignore: unnecessary_type_check
          final errorMessage = failure is Failure
              ? failure.getMessage() // Use the failure's message if available
              : "An unknown error occurred."; // Fallback message
          emit(PatientError(errorMessage)); // Ensure message is passed
        },
        // Execute success callback
        onSuccess,
      );
    } on TimeoutException {
      // Emit timeout-specific error
      emit(const PatientError("Request timed out. Please try again."));
    } catch (_) {
      // Emit a generic error for unexpected exceptions
      emit(const PatientError(noInternetErrorMessage));
    }
  }



    // Fetch all patients
    Future<void> fetchAllPatients() async {
      emit(PatientLoading());
      await _handleRequest(
        getAllPatientsUseCase.call(),
        (patients) => emit(PatientLoaded(patients: patients)),
      );
    }

    // Add a patient and update the cache
    Future<void> addPatient(Patient patient) async {
      emit(PatientLoading());
      await _handleRequest(
        addPatientUseCase.call(patient),
        (_) => emit(PatientAdded(patientName: patient.name)),
      );
    }

    // Edit a patient and update the cache
    Future<void> editPatient(Patient patient) async {
      emit(PatientLoading());
      await _handleRequest(
        editPatientUseCase.call(patient),
        (_) => emit(PatientUpdated(patient)),
      );
    }

    // Delete a patient and update the cache
    Future<void> deletePatient(String id) async {
      emit(PatientLoading());
      await _handleRequest(
        deletePatientUseCase.call(id),
        (_) => emit(PatientDelete()),
      );
    }

    void updatePatient(copyWith) {}
  }
