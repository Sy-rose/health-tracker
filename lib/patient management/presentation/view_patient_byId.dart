// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/core/services/injection_container.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_cubit.dart';

import 'view_patient_page.dart';

class PatientsByIdPage extends StatelessWidget {
   final List<String> patientIds;

  const PatientsByIdPage({
    super.key,
    required this.patientIds,
  });

  Future<Patient?> fetchPatientDetails(String patientId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        return Patient(
          id: patientId,
          name: data['name'] ?? 'Unknown Patient',
          age: data['age'] ?? 0,
          gender: data['gender'] ?? 'Unknown',
          contactInfo: data['contactInfo'] ?? '',
        );
      }
    } catch (e) {
      debugPrint('Error fetching patient details: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients List'),
      ),
      body: ListView.builder(
        itemCount: patientIds.length,
        itemBuilder: (context, index) {
          final patientId = patientIds[index];

          return FutureBuilder<Patient?>(
            future: fetchPatientDetails(patientId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Card(
                  child: ListTile(
                    title: Text('Loading...'),
                  ),
                );
              } else if (snapshot.hasError) {
                return Card(
                  child: ListTile(
                    title: const Text('Error fetching patient details'),
                    subtitle: Text(snapshot.error.toString()),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                // If the patient is not found, return an empty container to exclude this item from the list
                return Container();
              }

              final patient = snapshot.data!;
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(patient.name),
                  subtitle: Text('Age: ${patient.age}, Gender: ${patient.gender},Contact: ${patient.contactInfo}'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => serviceLocator<PatientCubit>(),
                          child: ViewPatientPage(patient: patient),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
