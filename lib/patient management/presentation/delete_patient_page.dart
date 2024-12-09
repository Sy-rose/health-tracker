import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_cubit.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_state.dart';

class DeletePatientPage extends StatefulWidget {
  final String patientId;
  final Patient patient;

  const DeletePatientPage({
    super.key,
    required this.patientId,
    required this.patient,
  });

  @override
  State<DeletePatientPage> createState() => _DeletePatientPageState();
}

class _DeletePatientPageState extends State<DeletePatientPage> {
  bool _isPerforming = false;

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
          'Are you sure you want to delete ${widget.patient.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              setState(() {
                _isPerforming = true;
              });
              context.read<PatientCubit>().deletePatient(widget.patientId);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientCubit, PatientState>(
      listener: (context, state) {
        if (state is PatientDelete) {
          // Show success message when deletion completes
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Patient ${widget.patient.name} deleted successfully!'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.pop(context, true); // Pop the current screen
        } else if (state is PatientError) {
          // Show error message if deletion fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          setState(() {
            _isPerforming = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Delete Patient'),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_remove,
                size: 150,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              Text(
                "Patient: ${widget.patient.name}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Age: ${widget.patient.age}",
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                "Gender: ${widget.patient.gender}",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Contact Number: ${widget.patient.contactInfo}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isPerforming
                    ? null
                    : () => _showDeleteConfirmationDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 30,
                  ),
                ),
                child: _isPerforming
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Delete Patient",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
