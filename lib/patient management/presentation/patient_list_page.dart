import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/core/services/injection_container.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_cubit.dart';

class PatientListPage extends StatelessWidget {
  final Patient patient; // HealthMetric passed from the previous page

  PatientListPage({super.key, required this.patient});

  // Mock data for patients (in a real app, you'd fetch this from a database or API)
  final List<Patient> allPatients = [
    const Patient(
        id: '1',
        name: 'John Doe',
        age: 28,
        gender: 'Male',
        contactInfo: 'john@example.com'),
    const Patient(
        id: '2',
        name: 'Jane Smith',
        age: 34,
        gender: 'Female',
        contactInfo: 'jane@example.com'),
    const Patient(
        id: '3',
        name: 'Sairose Johnson',
        age: 22,
        gender: 'Female',
        contactInfo: 'sairose@example.com'),
    const Patient(
        id: '4',
        name: 'Mark Johnson',
        age: 45,
        gender: 'Male',
        contactInfo: 'mark@example.com'),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter the patients based on the patientIds passed in the HealthMetric
    final List<Patient> patients = allPatients.where((patient) {
      return patient.patientIds.contains(patient.id); // Match patient IDs
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient List'),
      ),
      body: patients.isEmpty
          ? const Center(child: Text('No patients found.'))
          : ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return ListTile(
                  title: Text(patient.name),
                  subtitle: Text(
                      'Age: ${patient.age} | Gender: ${patient.gender}\nContact: ${patient.contactInfo}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddEditPatientPage
          final newPatientId = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => serviceLocator<PatientCubit>(),
                child: AddEditPatientPage(),
              ),
            ),
          );

          // Update patientIds if a new patient is added
          if (newPatientId != null && newPatientId.isNotEmpty) {
            patient.patientIds.add(newPatientId);

            // Optionally, call setState if you need to refresh the UI
            (context as Element).markNeedsBuild();
          }
        },
        tooltip: 'Add Patient',
        child: const Icon(Icons.add),
      ),
    );
  }
  
  // ignore: non_constant_identifier_names
  AddEditPatientPage() {}
}


