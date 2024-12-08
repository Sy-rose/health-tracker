import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/core/services/injection_container.dart';
import 'package:health_metrics_tracker/core/widgets/empty_state_list.dart';
import 'package:health_metrics_tracker/core/widgets/error_state_list.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_cubit.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_state.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/edit_patient_page.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/add_patient_page.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/delete_patient_page.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/viewpatientpage.dart';

class ViewAllPatientsPage extends StatefulWidget {
  const ViewAllPatientsPage({super.key});

  @override
  State<ViewAllPatientsPage> createState() => _ViewAllPatientsPageState();
}

class _ViewAllPatientsPageState extends State<ViewAllPatientsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PatientCubit>().fetchAllPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/Designer.png',
            height: 30,
            width: 30,
          ),
        ),
        title: const Text(
          "Patients",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 5,
      ),
      body: BlocBuilder<PatientCubit, PatientState>(
        builder: (context, state) {
          if (state is PatientLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PatientLoaded) {
            if (state.patients.isEmpty) {
              return const EmptyStateList(
                imageAssetName: 'assets/Designer.png',
                title: 'No Patients Found',
                description: 'Please add new patients.',
              );
            }

            // Reverse the patient list to show last added at the bottom
            final reversedPatients = List.from(state.patients.reversed);

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: reversedPatients.length,
              itemBuilder: (context, index) {
                final patient = reversedPatients[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    title: Text(
                      patient.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                    subtitle: Text(
                      '${patient.age} years old',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditPatientPage(patient: patient),
                              ),
                            ).then((shouldRefresh) {
                              if (shouldRefresh == true) {
                                // Refresh the list of patients
                                context.read<PatientCubit>().fetchAllPatients();
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Inside ViewAllPatientsPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeletePatientPage(
                                  patient: patient,
                                  patientId: patient.id,
                                ),
                              ),
                            ).then((_) {
                              // This will refresh the list when you come back from DeletePatientPage
                              context.read<PatientCubit>().fetchAllPatients();
                            });
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewPatientDetailsPage(patient: patient),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is PatientError) {
            return ErrorStateList(
              imageAssetName: 'assets/images/error.png',
              errorMessage: state.message,
              onRetry: () {
                context.read<PatientCubit>().fetchAllPatients();
              },
              message: 'An error occurred while loading the patients.',
            );
          } else {
            return const EmptyStateList(
              imageAssetName: 'assets/Designer.png',
              title: 'No Patients Found',
              description: 'Please add new patients to the system.',
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => serviceLocator<PatientCubit>(),
                child: const AddPatientPage(),
              ),
            ),
          );
          if (result == true) {
            // Refresh the patient list after adding a new patient
            context.read<PatientCubit>().fetchAllPatients();
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
