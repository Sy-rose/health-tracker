import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_cubit.dart';

class DeletePatientPage extends StatelessWidget {
  final String patientId;
  final Patient patient;

  const DeletePatientPage({
    super.key,
    required this.patientId,
    required this.patient,
  });

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
          'Are you sure you want to delete ${patient.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            // Inside DeletePatientPage
            onPressed: () {
              Navigator.of(context).pop(); // Close the DeletePatientPage
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Patient Deleted...'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
              context.read<PatientCubit>().deletePatient(patientId);

              // Pop the current screen and refresh the ViewAllPatientsPage
              Navigator.pop(
                  context); // Pop the current screen after deletion, returning to ViewAllPatientsPage
            },

            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Patient: ${patient.name}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Age: ${patient.age}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Gender: ${patient.gender}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Contact Number: ${patient.contactInfo}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _showDeleteConfirmationDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              ),
              child: const Text(
                "Delete Patient",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
